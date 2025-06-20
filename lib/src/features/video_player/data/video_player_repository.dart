import 'dart:io';

import 'package:dio/dio.dart';
import 'package:udevs/src/common/service/api_service.dart';

abstract class IVideoPlayerRepository {
  const IVideoPlayerRepository();

  Future<String> download({
    required String url,
    required String saveUrl,
    required void Function(int progress) onProgress,
    required Future<bool> Function() onPause,
  });
}

class VideoRepositoryImpl implements IVideoPlayerRepository {
  VideoRepositoryImpl({required this.apiService});

  final ApiService apiService;
  int _progress = 0;

  @override
  Future<String> download({
    required String url,
    required String saveUrl,
    required void Function(int progress) onProgress,
    required Future<bool> Function() onPause,
  }) async {
    try {
      String moviePath = "$saveUrl/${url.split("/").last}";

      print("Movie path: $moviePath");

      File file = File(moviePath);
      IOSink temp = file.openWrite(mode: FileMode.write);
      int received = 0;

      Response<ResponseBody> response = await apiService.dio.get<ResponseBody>(
        url,
        options: Options(responseType: ResponseType.stream),
      );

      print("Status code: ${response.statusCode}");
      final total = int.parse(
        response.headers.value(HttpHeaders.contentLengthHeader) ?? '0',
      );

      await for (final data in response.data!.stream) {
        if (await onPause()) {
          while (await onPause()) {
            print("While aylanmoqda!");
            await Future.delayed(Duration(milliseconds: 300));
          }
        }
        received += data.length;
        temp.add(data);
        if (_progress < (received * 100 / total).toInt()) {
          onProgress((received * 100 / total).toInt());
          _progress = (received * 100 / total).toInt();
        }
      }
      await temp.close();
      return moviePath;
    } on Exception catch (e) {
      print("Start download error: $e");
      return "";
    }
  }
}
