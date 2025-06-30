import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';

import '../../../common/service/api_service.dart';

abstract class IVideoPlayerRepository {
  const IVideoPlayerRepository();

  Future<String> startDownload({
    required String url,
    required String saveUrl,
    required void Function(double progress) onProgress,
  });

  void cancelVideoMp4();

  Future<String> downloadHls({
    required String url,
    required String saveUrl,
    required void Function(double progress) onProgress,
    Duration? fileDuration,
  });

  void cancelVideoHls();
}

class VideoRepositoryImpl implements IVideoPlayerRepository {
  VideoRepositoryImpl({required this.apiService});

  final ApiService apiService;
  CancelToken _cancelToken = CancelToken();
  double _progress = 0;

  @override
  Future<String> startDownload({
    required String url,
    required String saveUrl,
    required void Function(double progress) onProgress,
  }) async {
    _cancelToken = CancelToken();

    try {
      String moviePath = "$saveUrl/${url.split("/").last}";
      debugPrint("Movie path: $moviePath");

      File file = File(moviePath);
      int downloaded = file.existsSync() ? file.lengthSync() : 0;
      debugPrint("File length: $downloaded");

      Response headResponse = await apiService.dio.head(url);
      int? totalLength = int.tryParse(
        headResponse.headers.value('content-length') ?? '',
      );

      if (downloaded > 0 && totalLength != null) {
        _progress = downloaded * 100 / totalLength;
        onProgress(_progress);
      }

      if (totalLength != null && downloaded >= totalLength) {
        debugPrint("Fayl to'liq yuklab olingan: $downloaded / $totalLength");
        return "success";
      }

      Response response = await apiService.dio.download(
        url,
        moviePath,
        deleteOnError: false,
        cancelToken: _cancelToken,
        fileAccessMode:
            downloaded == 0 ? FileAccessMode.write : FileAccessMode.append,
        options: Options(headers: {'range': 'bytes=$downloaded-'}),
        onReceiveProgress: (received, total) {
          double result =
              (received + downloaded) / ((total + downloaded) / 100);
          if (_progress < result) {
            _progress = double.parse(result.toStringAsFixed(1));
            onProgress(_progress);
          }
        },
      );

      _progress = 0;

      debugPrint("Status code: ${response.statusCode}");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 299) {
        return moviePath;
      }
    } on Exception catch (e) {
      debugPrint("StartDownloadFunction(error: $e)");
    } finally {
      _progress = 0;
    }
    return "";
  }

  @override
  void cancelVideoMp4() {
    _cancelToken.cancel("Paused");
    _cancelToken;
  }

  @override
  Future<String> downloadHls({
    required String url,
    required String saveUrl,
    required void Function(double progress) onProgress,
    Duration? fileDuration,
  }) async {
    try {
      Response<String> response = await apiService.dio.get(url);

      debugPrint("Download m3u8: ${response.data}");
      debugPrint("Url m3u8: $url");
      debugPrint("Download path: $saveUrl");

      final duration = await _getVideoDuration(
        url.replaceAll('playlist.m3u8', 'video/4000kbit.m3u8'),
      );

      debugPrint("File duration: ${fileDuration?.inSeconds}");
      debugPrint("Duration: ${duration.inSeconds}");

      if (fileDuration != null &&
          duration.inSeconds == fileDuration.inSeconds) {
        return "success";
      } else if (File(saveUrl).existsSync()) {
        File(saveUrl).deleteSync();
      }

      FFmpegKitConfig.enableLogCallback((log) {
        String message = log.getMessage();

        if (message.contains("time=")) {
          RegExp regExp = RegExp(r'time=([0-9:.]+)');
          RegExpMatch? match = regExp.firstMatch(message);
          if (match != null) {
            String? currentTime = match.group(1);
            if (currentTime != null) {
              _updateProgress(currentTime, duration, onProgress);
            } else {
              debugPrint("Qandaydir hatolik yuzaga keldi!");
            }
          }
        }
      });

      final responseSession = await FFmpegKit.execute(
        "-i '${url.replaceAll(url.split("/").last, 'video/4000kbit.m3u8')}' "
        "-i '${url.replaceAll(url.split("/").last, 'audio/surround/en/320kbit.m3u8')}' "
        "-c:v copy -c:a aac "
        "-map 0:v:0 -map 1:a:0 "
        "'$saveUrl'",
      );

      if (ReturnCode.isSuccess(await responseSession.getReturnCode())) {
        debugPrint("Success");
      } else if (ReturnCode.isCancel(await responseSession.getReturnCode())) {
        debugPrint("2 Cancel");

        if (File(saveUrl).existsSync()) File(saveUrl).deleteSync();

        return "cancel";
      } else {
        debugPrint("Failed");

        return "failed";
      }

      return saveUrl;
    } on Exception catch (e) {
      debugPrint("DownloadM3u8Function(error: $e)");
      return "";
    } finally {
      _progress = 0;
    }
  }

  @override
  void cancelVideoHls() async {
    await FFmpegKit.cancel();
  }

  Future<Duration> _getVideoDuration(String path) async {
    final session = await FFprobeKit.getMediaInformation(path);
    final info = session.getMediaInformation();
    final durationStr = info?.getDuration();

    if (durationStr != null) {
      final seconds =
          (double.parse(durationStr) - double.parse(durationStr).floor()) >= 0.5
              ? double.parse(durationStr).ceil()
              : double.parse(durationStr).floor();
      return Duration(seconds: seconds);
    }
    return Duration.zero;
  }

  void _updateProgress(
    String timeStr,
    Duration totalDuration,
    void Function(double progress) onProgress,
  ) {
    final parts = timeStr.split(":");
    if (parts.length == 3) {
      final seconds =
          int.parse(parts[0]) * 3600 +
          int.parse(parts[1]) * 60 +
          double.parse(parts[2]);
      _progress = seconds / totalDuration.inSeconds;
      onProgress(double.parse(_progress.toStringAsFixed(3)) * 100);
    }
  }
}
