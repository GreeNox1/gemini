import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/second_screen.dart';

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
  initialLocation: AppRouter.home,
  routes: [
    GoRoute(
      path: AppRouter.home,
      name: AppRouter.home,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: AppRouter.second,
      name: AppRouter.second,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: SecondScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
  ],
);
