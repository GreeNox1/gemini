import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:udevs/src/common/utils/exception/api_error.dart';
import 'package:udevs/src/common/utils/exception/no_connection.dart';

enum Method { get, post, put, delete }

class ApiService {
  ApiService({required this.dio});

  final Dio dio;

  Future<bool> _checkConnection() async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity.contains(ConnectivityResult.mobile) ||
        connectivity.contains(ConnectivityResult.wifi) ||
        connectivity.contains(ConnectivityResult.ethernet)) {
      return true;
    }
    return false;
  }

  Future<Map<String, Object?>> request(
    String path, {
    Method method = Method.get,
    Object? data,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    FormData? formData,
  }) async {
    if (!await _checkConnection()) throw Connection(text: "No Connection");

    try {
      final requestHeaders = {
        ...?headers,
        'content-Type':
            formData != null ? 'multipart/form-data' : 'application-json',
      };

      final response = await dio.request<Map<String, Object?>>(
        path,
        data: data ?? formData,
        queryParameters: queryParams,
        options: Options(method: method.name, headers: requestHeaders),
      );

      if (response.statusCode == null ||
          response.statusCode! > 204 ||
          response.data == null) {
        throw ApiError(text: "API error. Status code: ${response.statusCode}");
      }

      return response.data ?? <String, Object?>{};
    } on Object catch (_) {
      rethrow;
    }
  }
}
