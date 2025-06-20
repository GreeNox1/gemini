import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';

import '../../features/gemini_ai/bloc/gemini_ai_bloc.dart';
import '../../features/gemini_ai/screen/gemini_ai_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/second_screen.dart';
import '../../features/underground_railway/screens/railway_screen.dart';

class AppRouter {
  const AppRouter._();

  static const String home = "/home";
  static const String second = "/second";
  static const String geminiAi = "/gemini_ai";
  static const String undergroundRailway = "/underground_railway";
  static const String foldersVideoPlayer = "/folders_video_player";
  static const String videoListVideoPlayer = "/video_list_video_player";

  static Route<Object?> onGenerateRoute(RouteSettings setting) {
    return switch (setting.name) {
      home => MaterialPageRoute(
        builder: (context) => HomeScreen(),
        settings: RouteSettings(name: AppRouter.home),
      ),
      second => MaterialPageRoute(
        builder: (context) => SecondScreen(),
        settings: RouteSettings(name: AppRouter.second),
      ),
      geminiAi => MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (BuildContext context) {
                return GeminiAiBloc(
                  homeRepository: context.dependency.geminiAiRepository,
                );
              },
              child: const GeminiAiScreen(),
            ),
        settings: RouteSettings(name: AppRouter.geminiAi),
      ),
      undergroundRailway => MaterialPageRoute(
        builder: (context) => UndergroundRailwayScreen(),
        settings: RouteSettings(name: AppRouter.undergroundRailway),
      ),
      _ => MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text(
                "Error Screen",
                style: context.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          );
        },
      ),
    };
  }
}
