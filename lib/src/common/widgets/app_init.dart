import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/gemini_ai/data/gemini_ai_repository.dart';
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

    return AppDependencies(
      locale: locale,
      theme: theme,
      shp: shp,
      geminiAiRepository: geminiAiRepository,
    );
  }
}
