import 'package:shared_preferences/shared_preferences.dart';

import '../../features/gemini_ai/data/gemini_ai_repository.dart';
import '../../features/video_player/data/video_player_repository.dart';

class AppDependencies {
  AppDependencies({
    required this.locale,
    required this.theme,
    required this.shp,
    required this.geminiAiRepository,
    required this.videoPlayerRepository,
  });

  String locale;
  bool theme;

  final SharedPreferences shp;

  final IGeminiAiRepository geminiAiRepository;
  final IVideoPlayerRepository videoPlayerRepository;
}
