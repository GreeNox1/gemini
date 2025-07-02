import 'package:shared_preferences/shared_preferences.dart';

import '../../features/gemini_ai/data/gemini_ai_repository.dart';

class AppDependencies {
  AppDependencies({
    required this.locale,
    required this.theme,
    required this.shp,
    required this.geminiAiRepository,
  });

  String locale;
  bool theme;

  final SharedPreferences shp;

  final IGeminiAiRepository geminiAiRepository;
}
