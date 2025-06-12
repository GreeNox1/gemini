import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:udevs/src/common/constants/constants.dart';
import 'package:udevs/src/common/dependency/app_dependencies.dart';
import 'package:udevs/src/common/service/api_service.dart';
import 'package:udevs/src/features/home/data/home_repository.dart';

class InitializeApp {
  const InitializeApp._();

  static Future<AppDependencies> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Gemini.init(apiKey: AppConstants.apiKey);

    // final bool theme = shp.getBool(Constants.theme) ?? true;
    // final String locale = shp.getString(Constants.locale) ?? "en";

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(seconds: 30),
        sendTimeout: Duration(seconds: 30),
      ),
    );

    final apiService = ApiService(dio: dio);

    final IHomeRepository homeRepository = HomeRepositoryImpl(
      apiService: apiService,
    );

    return AppDependencies(homeRepository: homeRepository);
  }
}
