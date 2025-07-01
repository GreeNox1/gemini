import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../../../common/constants/constants.dart';
import '../../../common/model/video_model.dart';
import '../../../common/router/app_router.dart';
import '../../../common/style/app_size.dart';
import '../../../common/utils/enums/download.dart';
import '../../../common/utils/enums/status.dart';
import '../../../common/utils/extension/context_extension.dart';
import '../data/video_player_repository.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerBloc({required final IVideoPlayerRepository videoPlayerRepository})
    : _videoPlayerRepository = videoPlayerRepository,
      super(const VideoPlayerState()) {
    on<VideoPlayerEvent>(
      (event, emit) => switch (event) {
        CheckPermission$VideoPlayerEvent _ => _checkPermission(event, emit),
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
    '.mov',
    '.flv',
    '.m3u8',
  ];

  bool _isPause = true;

  Future<void> _checkPermission(
    CheckPermission$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final responseMediaLibrary = await Permission.mediaLibrary.request();
    final responseExternalStorage =
        await Permission.manageExternalStorage.request();

    debugPrint("Media Library: ${responseMediaLibrary.isGranted}");
    debugPrint(
      "Response External storage: ${responseExternalStorage.isGranted}",
    );

    if (responseExternalStorage.isGranted) {
      emit(state.copyWith(status: Status.success, checkPermission: true));
    } else {
      emit(state.copyWith(status: Status.error));
    }
  }

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

      debugPrint(onlineVideos.toString());

      await event.context.dependency.shp.setString(
        AppConstants.videoStorage,
        toJsonVideoModel(videos),
      );

      emit(state.copyWith(status: Status.success, videos: videos));
    } catch (e) {
      emit(state.copyWith(status: Status.error, videos: []));
      debugPrint("GetVideoAllBloc(error: $e)");
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
      debugPrint("UpdateVideoBloc(error: $e)");
    }
  }

  // DownloadVideo$VideoPlayerEvent

  Future<void> _downloadVideo(
    DownloadVideo$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (Download.progress == state.download) {
      if (event.context.mounted) {
        _showSnackBar("Video yuklanmoqda", event.context);
      }
      return;
    }

    debugPrint("Is pause: $_isPause");

    _isPause = !_isPause;

    emit(
      state.copyWith(
        status: Status.loading,
        videoIndex: event.index,
        download: Download.progress,
        isDownload: _isPause,
      ),
    );

    try {
      final videos = [...state.videos];

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

        appDirectory = await _createDirectory(baseDir);

        await event.context.dependency.shp.setString(
          AppConstants.appDirectoryStorage,
          appDirectory,
        );
      }

      String result = "";
      String saveUrl = "$appDirectory/Sintel.mp4";

      if (!event.url.endsWith(".m3u8")) {
        result = await _videoPlayerRepository.startDownload(
          url: event.url,
          saveUrl: appDirectory,
          onProgress: (progress) {
            add(
              DownloadVideoInProgress$VideoPlayerEvent(
                context: event.context,
                percent: progress,
              ),
            );
          },
        );

        if (result.isEmpty) {
          debugPrint("Yuklab olishda xatolik!");
          emit(state.copyWith(status: Status.error));
          return;
        }
      } else {
        if (event.context.mounted) {
          _showDialog(
            "Bu videoni yuklayotgan paytingizda bu ekrandan chiqib ketsangiz "
            "yoki videoni pause qilsangiz, video yuklab olishdan to'xtatiladi."
            "\nNoqulaylik uchun uzur",
            event.context,
          );
        }
        result = await _videoPlayerRepository.downloadHls(
          url: event.url,
          saveUrl: saveUrl,
          onProgress: (progress) {
            add(
              DownloadVideoInProgress$VideoPlayerEvent(
                context: event.context,
                percent: progress,
              ),
            );
          },
          fileDuration:
              File(saveUrl).existsSync()
                  ? await _getDuration(File(saveUrl))
                  : null,
        );
        if (result.isEmpty) {
          debugPrint("Yuklab olishda xatolik!");
          emit(state.copyWith(status: Status.error));
          return;
        }
      }

      if (event.context.mounted) {
        if (result == "failed") {
          _showSnackBar("Video yuklab olishda hatolik", event.context);
        } else if (result == "cancel") {
          _showSnackBar("Video yuklab olish to'xtatildi", event.context);
        } else if (result.isNotEmpty) {
          _showSnackBar("Video to'liq yuklab olindi", event.context);
        }
      }

      if (result == "success" && event.context.mounted) {
        _isPause = true;

        _showSnackBar("Video to'liq yuklab olingan", event.context);

        emit(
          state.copyWith(
            status: Status.success,
            videoIndex: -1,
            download: Download.start,
            isDownload: _isPause,
          ),
        );
        return;
      }

      final file = File(result);
      final uint8list = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 150,
        quality: 100,
      );

      try {
        Duration duration = await _getDuration(file) ?? Duration();

        final downloaded = VideoDataModel(
          text: file.path,
          uint8list: uint8list,
          duration: duration,
        );

        final index = videos.indexWhere((e) => e.fileName == "Video player");

        if (index != -1) {
          videos[index].videos.add(downloaded);
        } else {
          videos.add(
            VideoModel(fileName: "Video player", videos: [downloaded]),
          );
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
      } on Object catch (_) {}
    } catch (e) {
      debugPrint("DownloadVideoBloc(error: $e)");

      _isPause = !_isPause;

      emit(
        state.copyWith(
          status: Status.error,
          videoIndex: -1,
          download: Download.start,
          isDownload: _isPause,
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
      final file = File(event.path);
      if (await file.exists()) {
        await file.delete();
      }

      final dataAsString = event.context.dependency.shp.getString(
        AppConstants.videoStorage,
      );

      if (dataAsString != null) {
        final cachedVideos = fromJsonVideoModel(dataAsString);

        for (int i = 0; i < cachedVideos.length; i++) {
          final model = cachedVideos[i];
          final indexToRemove = model.videos.indexWhere(
            (element) => element.text == event.path,
          );
          if (indexToRemove != -1) {
            model.videos.removeAt(indexToRemove);
            if (model.videos.isEmpty) {
              cachedVideos.removeAt(i);
              if (event.context.mounted) {
                event.context.go(AppRouter.foldersVideoPlayer);
              }
            }
            await event.context.dependency.shp.setString(
              AppConstants.videoStorage,
              toJsonVideoModel(cachedVideos),
            );
            break;
          }
        }

        if (event.context.mounted) {
          add(UpdateVideo$VideoPlayerEvent(context: event.context));
        }

        if (event.context.mounted) {
          _showSnackBar("Video o'chirildi", event.context);
        }

        emit(state.copyWith(status: Status.success, videos: cachedVideos));
      } else {
        emit(state.copyWith(status: Status.success));
      }
    } catch (e) {
      debugPrint("DeleteVideoBloc(error: $e)");
      emit(state.copyWith(status: Status.error));
    }
  }

  // PauseVideo$VideoPlayerEvent

  void _pauseVideo(
    PauseVideo$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) {
    emit(state.copyWith(status: Status.loading));

    _isPause = !_isPause;

    _videoPlayerRepository.cancelVideoHls();
    _videoPlayerRepository.cancelVideoMp4();

    emit(
      state.copyWith(
        status: Status.success,
        download: _isPause ? Download.pause : Download.progress,
        isDownload: _isPause,
      ),
    );
  }

  // DownloadVideoInProgress$VideoPlayerEvent

  void _progress(
    DownloadVideoInProgress$VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) {
    emit(state.copyWith(status: Status.loading));

    if (state.progress < event.percent) {
      debugPrint("Yuklab olindi: ${event.percent} %");

      emit(state.copyWith(status: Status.success, progress: event.percent));
      return;
    }

    emit(state.copyWith(status: Status.success));
  }

  // --------- Functions ---------

  Future<List<VideoModel>> _scanVideos(Directory baseDirectory) async {
    final videos = <VideoModel>[];
    final videoNames = <VideoDataModel>[];

    for (final entity in baseDirectory.listSync()) {
      if (_isValidVideoFile(entity.path)) {
        final videoData = await _generateVideoData(File(entity.path));
        if (videoData != null) videoNames.add(videoData);
      } else if (_hasAllowedFolderWithVideos(entity.path)) {
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
      final session = await FFprobeKit.getMediaInformation(url);
      final info = session.getMediaInformation();

      final imagePath =
          "$thumbnailPath/${url.split("/").last.replaceAll(url.split(".").last, "jpeg")}";

      final command =
          '-y -ss 00:00:10 -i "$url" -vframes 1 -q:v 2 -vf "scale=-1:720" "$imagePath"';

      await FFmpegKit.execute(command);

      double time = double.parse(info?.getDuration() ?? "0");

      videoNames.add(
        VideoDataModel(
          urlVideo: url,
          text: url.replaceAll("playlist.m3u8", "Sintel.mp4"),
          uint8list: File(imagePath).readAsBytesSync(),
          duration: Duration(
            minutes: time ~/ 60,
            seconds: ((time / 60 - time ~/ 60) * 60).floor(),
          ),
        ),
      );
    }
    if (videoNames.isNotEmpty) {
      return VideoModel(fileName: "Online videos", videos: videoNames);
    }
    return null;
  }

  Future<VideoDataModel?> _generateVideoData(File file) async {
    try {
      final session = await FFprobeKit.getMediaInformation(file.path);
      final info = session.getMediaInformation();

      final uint8list = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        timeMs: 10000,
        maxHeight: 150,
        quality: 100,
      );

      double time = double.parse(info?.getDuration() ?? "0");

      final data = VideoDataModel(
        text: file.path,
        uint8list: uint8list,
        duration: Duration(
          minutes: time ~/ 60,
          seconds: ((time / 60 - time ~/ 60) * 60).floor(),
        ),
      );
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

  bool _hasAllowedFolderWithVideos(String path) {
    final allowedFolders = {
      "Video player",
      "Download",
      "Telegram Video",
      "Camera",
      "Pictures",
      "Movies",
    };

    final folderName = path.split('/').last;

    if (folderName.startsWith('.') || !allowedFolders.contains(folderName)) {
      return false;
    }

    final type = FileSystemEntity.typeSync(path);
    if (type != FileSystemEntityType.directory) return false;

    try {
      final files = Directory(path).listSync();

      for (var file in files) {
        if (file is File) {
          final ext = file.path.toLowerCase();
          if (_videoExtensions.any((element) => ext.endsWith(element))) {
            return true;
          }
        }
      }

      return false;
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
        } else if (_hasAllowedFolderWithVideos(entity.path)) {
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

  Future<Duration?> _getDuration(File file) async {
    final controller = VideoPlayerController.file(file);

    try {
      await controller.initialize();

      return controller.value.duration;
    } on Object catch (e) {
      debugPrint("GetDuration(error: $e)");
      return null;
    } finally {
      await controller.dispose();
    }
  }

  void _showSnackBar(String title, BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppSize.borderRadiusAll15,
          ),
          content: Text(
            title,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
      );
  }

  void _showDialog(String title, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(
              "Info",
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colors.onPrimaryFixed,
              ),
            ),
            content: Text(
              title,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.onPrimaryFixed,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  "Close",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colors.onPrimaryFixed,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
