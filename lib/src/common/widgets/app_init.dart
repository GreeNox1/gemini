import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../dependency/app_dependencies.dart';

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

    return AppDependencies(locale: locale, theme: theme, shp: shp);
  }
}
