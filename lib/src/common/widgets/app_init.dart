import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/video_player/data/video_player_repository.dart';
import '../constants/constants.dart';
import '../dependency/app_dependencies.dart';
import '../service/api_service.dart';

class InitializeApp {
  const InitializeApp._();

  static Future<AppDependencies> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final SharedPreferences shp = await SharedPreferences.getInstance();

    final bool theme = shp.getBool(AppConstants.theme) ?? true;
    final String locale = shp.getString(AppConstants.locale) ?? "en";

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(seconds: 30),
        sendTimeout: Duration(seconds: 30),
      ),
    );

    final apiService = ApiService(dio: dio);

    final IVideoPlayerRepository videoPlayerRepository = VideoRepositoryImpl(
      apiService: apiService,
    );

    return AppDependencies(
      locale: locale,
      theme: theme,
      shp: shp,
      videoPlayerRepository: videoPlayerRepository,
    );
  }
}
