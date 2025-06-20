import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udevs/src/common/constants/constants.dart';
import 'package:udevs/src/common/dependency/app_dependencies.dart';
import 'package:udevs/src/common/service/api_service.dart';
import 'package:udevs/src/features/gemini_ai/data/gemini_ai_repository.dart';
import 'package:udevs/src/features/video_player/data/video_player_repository.dart';

class InitializeApp {
  const InitializeApp._();

  static Future<AppDependencies> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    Gemini.init(apiKey: AppConstants.aiApiKey);

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

    final IGeminiAiRepository geminiAiRepository = GeminiAiRepositoryImpl(
      apiService: apiService,
    );
    final IVideoPlayerRepository videoPlayerRepository = VideoRepositoryImpl(
      apiService: apiService,
    );

    return AppDependencies(
      locale: locale,
      theme: theme,
      shp: shp,
      geminiAiRepository: geminiAiRepository,
      videoPlayerRepository: videoPlayerRepository,
    );
  }
}
