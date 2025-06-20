import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:udevs/src/common/constants/constants.dart';
import 'package:udevs/src/common/utils/enums/download.dart';
import 'package:udevs/src/common/utils/enums/status.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';
import 'package:udevs/src/features/video_player/model/video_model.dart';
import 'package:video_player/video_player.dart';

import '../data/video_player_repository.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerBloc({required final IVideoPlayerRepository videoPlayerRepository})
    : _videoPlayerRepository = videoPlayerRepository,
      super(const VideoPlayerState()) {
    on<VideoPlayerEvent>(
      (event, emit) => switch (event) {
        GetVideoAll$VideoPlayerEvent _ => _getVideoAll(event, emit),
        UpdateVideo$VideoPlayerEvent _ => _updateVideo(event, emit),
        DownloadVideo$VideoPlayerEvent _ => _downloadVideo(event, emit),
        DeleteVideo$VideoPlayerEvent _ => _deleteVideo(event, emit),
        PauseVideo$VideoPlayerEvent _ => _pauseVideo(event, emit),
        DownloadVideoInProgress$VideoPlayerEvent _ => _progress(event, emit),
      },
    );
  }

  final IVideoPlayerRepository _videoPlayerRepository;

  static const List<String> _videoExtensions = [
    '.mp4',
    '.mkv',
    '.avi',
    '.webm',
    '.m3u8',
  ];

  bool _isPause = false;

  // GetVideoAll$VideoPlayerEvent

  Future<void> _getVideoAll(
    GetVideoAll$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final dataAsString = event.context.dependency.shp.getString(
        AppConstants.videoStorage,
      );
      if (dataAsString != null) {
        final cachedVideos = fromJsonVideoModel(dataAsString);
        emit(state.copyWith(status: Status.success, videos: cachedVideos));
        return;
      }

      final videos = <VideoModel>[];
      final directory = Directory(
        Platform.isAndroid ? "/storage/emulated/0" : "/",
      );

      if (!await Permission.manageExternalStorage.isGranted) {
        debugPrint("Xotiradan foydalanishga ruhsat berilmagan!");
        return;
      }

      String? appPath = event.context.dependency.shp.getString(
        AppConstants.appDirectoryStorage,
      );

      if (appPath == null) {
        appPath = await _createDirectory(directory);

        await event.context.dependency.shp.setString(
          AppConstants.appDirectoryStorage,
          appPath,
        );
      }

      final scannedVideos = await _scanVideos(directory);
      videos.addAll(scannedVideos);

      String? thumbnailPath = event.context.dependency.shp.getString(
        AppConstants.appThumbnailStorage,
      );

      if (thumbnailPath == null) {
        thumbnailPath = await _createDirectoryForThumbnails(appPath);

        await event.context.dependency.shp.setString(
          AppConstants.appThumbnailStorage,
          thumbnailPath,
        );
      }

      final onlineVideos = await _fetchOnlineVideos(thumbnailPath);
      if (onlineVideos != null) videos.add(onlineVideos);

      await event.context.dependency.shp.setString(
        AppConstants.videoStorage,
        toJsonVideoModel(videos),
      );

      emit(state.copyWith(status: Status.success, videos: videos));
    } catch (e) {
      emit(state.copyWith(status: Status.error, videos: []));
      debugPrint("GetVideoAll Error: $e");
    }
  }

  // UpdateVideo$VideoPlayerEvent

  Future<void> _updateVideo(
    UpdateVideo$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final directory = Directory(
        Platform.isAndroid ? "/storage/emulated/0" : "/",
      );
      final updatedVideos = await _scanVideos(directory);

      String? appPath = event.context.dependency.shp.getString(
        AppConstants.appDirectoryStorage,
      );

      if (appPath == null) {
        appPath = await _createDirectory(directory);

        await event.context.dependency.shp.setString(
          AppConstants.appDirectoryStorage,
          appPath,
        );
      }

      String? thumbnailPath = event.context.dependency.shp.getString(
        AppConstants.appThumbnailStorage,
      );

      if (thumbnailPath == null) {
        thumbnailPath = await _createDirectoryForThumbnails(directory.path);

        await event.context.dependency.shp.setString(
          AppConstants.appThumbnailStorage,
          thumbnailPath,
        );
      }

      final onlineVideos = await _fetchOnlineVideos(thumbnailPath);
      if (onlineVideos != null) updatedVideos.add(onlineVideos);

      await event.context.dependency.shp.setString(
        AppConstants.videoStorage,
        toJsonVideoModel(updatedVideos),
      );

      emit(state.copyWith(status: Status.success, videos: updatedVideos));
    } catch (e) {
      emit(state.copyWith(status: Status.error, videos: []));
      debugPrint("UpdateVideo Error: $e");
    }
  }

  // DownloadVideo$VideoPlayerEvent

  Future<void> _downloadVideo(
    DownloadVideo$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        videoIndex: event.index,
        download: Download.progress,
        isDownload: _isPause,
      ),
    );
    try {
      String? appDirectory = event.context.dependency.shp.getString(
        AppConstants.appDirectoryStorage,
      );

      if (appDirectory == null || appDirectory.isEmpty) {
        final baseDir = Directory(
          Platform.isAndroid ? "/storage/emulated/0" : "/",
        );
        if (!await Permission.manageExternalStorage.isGranted) {
          debugPrint("Fayl ochishga ruhsat berilmadi!");
          return;
        }
        String? appDirectory = event.context.dependency.shp.getString(
          AppConstants.appDirectoryStorage,
        );

        if (appDirectory == null) {
          appDirectory = await _createDirectory(baseDir);

          await event.context.dependency.shp.setString(
            AppConstants.appDirectoryStorage,
            appDirectory,
          );
        }
      }

      final result = await _videoPlayerRepository.download(
        url: event.url,
        saveUrl: appDirectory!,
        onProgress: (progress) {
          add(
            DownloadVideoInProgress$VideoPlayerEvent(
              context: event.context,
              percent: progress,
            ),
          );
        },
        onPause: () async {
          return _isPause;
        },
      );
      if (result.isEmpty) {
        debugPrint("Yuklab olishda xatolik!");
        emit(state.copyWith(status: Status.error));
        return;
      }

      final file = File(result);
      final uint8list = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 150,
        quality: 100,
      );
      final controller = VideoPlayerController.file(file);
      await controller.initialize();

      final downloaded = VideoDataModel(
        text: file.path,
        uint8list: uint8list,
        duration: controller.value.duration,
      );
      controller.dispose();

      final videos = [...state.videos];
      final index = videos.indexWhere((e) => e.fileName == "Video player");

      if (index != -1) {
        videos[index].videos.add(downloaded);
      } else {
        videos.add(VideoModel(fileName: "Video player", videos: [downloaded]));
      }

      await event.context.dependency.shp.setString(
        AppConstants.videoStorage,
        toJsonVideoModel(videos),
      );

      if (event.context.mounted) {
        add(UpdateVideo$VideoPlayerEvent(context: event.context));
      }

      emit(
        state.copyWith(
          status: Status.success,
          videos: videos,
          videoIndex: -1,
          download: Download.start,
        ),
      );
    } catch (e) {
      debugPrint("DownloadVideo Error: $e");
      emit(
        state.copyWith(
          status: Status.error,
          videoIndex: -1,
          download: Download.start,
        ),
      );
    }
  }

  // DeleteVideo$VideoPlayerEvent

  Future<void> _deleteVideo(
    DeleteVideo$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      File file = File(event.path);
      await file.delete();

      final dataAsString = event.context.dependency.shp.getString(
        AppConstants.videoStorage,
      );
      if (dataAsString != null) {
        final cachedVideos = fromJsonVideoModel(dataAsString);

        for (int i = 0; i < cachedVideos.length; i++) {
          if (event.path.contains(cachedVideos[i].fileName)) {
            for (int j = 0; j < cachedVideos[i].videos.length; j++) {
              if (event.path.contains(cachedVideos[i].videos[j].text)) {
                cachedVideos[i].videos.removeAt(j);
                await event.context.dependency.shp.setString(
                  AppConstants.videoStorage,
                  toJsonVideoModel(cachedVideos),
                );
                emit(
                  state.copyWith(status: Status.success, videos: cachedVideos),
                );
                return;
              }
            }
          }
        }

        emit(state.copyWith(status: Status.success, videos: cachedVideos));
      }

      emit(state.copyWith(status: Status.success));
    } on Exception catch (e) {
      debugPrint("Delete video: $e");
      emit(state.copyWith(status: Status.error));
    }
  }

  // PauseVideo$VideoPlayerEvent

  Future<void> _pauseVideo(
    PauseVideo$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, download: Download.progress));

    _isPause = !_isPause;

    emit(
      state.copyWith(
        status: Status.success,
        download: _isPause ? Download.pause : Download.progress,
        isDownload: _isPause,
      ),
    );
  }

  // DownloadVideoInProgress$VideoPlayerEvent

  Future<void> _progress(
    DownloadVideoInProgress$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    if (state.progress < event.percent) {
      debugPrint("Yuklab olindi: ${event.percent} %");

      emit(state.copyWith(status: Status.success, progress: event.percent));
      return;
    }

    emit(state.copyWith(status: Status.success));
  }

  Future<List<VideoModel>> _scanVideos(Directory baseDirectory) async {
    final videos = <VideoModel>[];
    final videoNames = <VideoDataModel>[];

    for (final entity in baseDirectory.listSync()) {
      print("Path: ${entity.path}");
      if (_isValidVideoFile(entity.path)) {
        final videoData = await _generateVideoData(File(entity.path));
        if (videoData != null) videoNames.add(videoData);
      } else if (_isValidNonEmptyDirectory(entity.path)) {
        videos.addAll(await _readFile(entity.path));
      }
    }

    if (videoNames.isNotEmpty) {
      videos.add(VideoModel(fileName: "Internal memory", videos: videoNames));
    }

    return videos;
  }

  Future<VideoModel?> _fetchOnlineVideos(String thumbnailPath) async {
    final videoNames = <VideoDataModel>[];
    for (final url in AppConstants.movies) {
      if (url.endsWith(".m3u8")) continue;
      final file = await VideoThumbnail.thumbnailFile(
        video: url,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.WEBP,
        timeMs: 10000,
        maxHeight: 150,
        quality: 100,
      );
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      videoNames.add(
        VideoDataModel(
          urlVideo: url,
          text: url,
          uint8list: await file.readAsBytes(),
          duration: controller.value.duration,
        ),
      );
      controller.dispose();
    }
    if (videoNames.isNotEmpty) {
      return VideoModel(fileName: "Online videos", videos: videoNames);
    }
    return null;
  }

  Future<VideoDataModel?> _generateVideoData(File file) async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        timeMs: 10000,
        maxHeight: 150,
        quality: 100,
      );
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      final data = VideoDataModel(
        text: file.path,
        uint8list: uint8list,
        duration: controller.value.duration,
      );
      controller.dispose();
      return data;
    } catch (_) {
      return null;
    }
  }

  bool _isValidVideoFile(String path) {
    return _videoExtensions.any(
      (element) => path.toLowerCase().endsWith(element),
    );
  }

  bool _isValidNonEmptyDirectory(String path) {
    final notIgnored = {
      "Video player",
      "Download",
      "Telegram Video",
      "Camera",
      "Pictures",
      "Movies",
    };
    final name = path.split('/').last;
    if (name.startsWith('.') || !notIgnored.contains(name)) return false;
    final type = FileSystemEntity.typeSync(path);
    if (type != FileSystemEntityType.directory) return false;
    try {
      return Directory(path).listSync().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<List<VideoModel>> _readFile(String path) async {
    final videos = <VideoModel>[];
    final videoNames = <VideoDataModel>[];

    try {
      for (final entity in Directory(path).listSync()) {
        if (_isValidVideoFile(entity.path)) {
          final videoData = await _generateVideoData(File(entity.path));
          if (videoData != null) videoNames.add(videoData);
        } else if (_isValidNonEmptyDirectory(entity.path)) {
          videos.addAll(await _readFile(entity.path));
        }
      }

      if (videoNames.isNotEmpty) {
        videos.add(
          VideoModel(fileName: path.split("/").last, videos: videoNames),
        );
      }
    } catch (_) {}

    return videos;
  }

  Future<String> _createDirectory(Directory directory) async {
    final newDir = Directory("${directory.path}/Video player");
    return (await newDir.create()).path;
  }

  Future<String> _createDirectoryForThumbnails(String path) async {
    final newDir = Directory("$path/Thumbnails");
    return (await newDir.create()).path;
  }
}
