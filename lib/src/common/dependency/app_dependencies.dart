import 'package:shared_preferences/shared_preferences.dart';

import '../../features/video_player/data/video_player_repository.dart';

class AppDependencies {
  AppDependencies({
    required this.locale,
    required this.theme,
    required this.shp,
    required this.videoPlayerRepository,
  });

  String locale;
  bool theme;

  final SharedPreferences shp;

  final IVideoPlayerRepository videoPlayerRepository;
}
