import 'package:udevs/src/features/gemini_ai/data/gemini_ai_repository.dart';

class AppDependencies {
  AppDependencies({
    this.locale = "en",
    this.theme = true,
    required this.geminiAiRepository,
  });

  String locale;
  bool theme;

  final IGeminiAiRepository geminiAiRepository;
}
