import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/underground_railway/screens/railway_screen.dart';

class AppRouter {
  const AppRouter._();

  static const String home = "/home";
  static const String second = "/second";
  static const String geminiAi = "/gemini_ai";
  static const String undergroundRailway = "/underground_railway";
  static const String foldersVideoPlayer = "/folders_video_player";
  static const String videoListVideoPlayer = "/video_list_video_player";
  static const String playVideoPlayer = "/play_video_player";
  static const String permission = "/permission";
}

final navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: AppRouter.undergroundRailway,
  routes: [
    GoRoute(
      path: AppRouter.undergroundRailway,
      name: AppRouter.undergroundRailway,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: UndergroundRailwayScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
  ],
);
