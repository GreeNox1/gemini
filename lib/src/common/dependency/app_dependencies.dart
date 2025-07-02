import 'package:shared_preferences/shared_preferences.dart';

class AppDependencies {
  AppDependencies({
    required this.locale,
    required this.theme,
    required this.shp,
  });

  String locale;
  bool theme;

  final SharedPreferences shp;
}
