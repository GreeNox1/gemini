import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/gemini_ai/bloc/gemini_ai_bloc.dart';
import '../../features/gemini_ai/screen/gemini_ai_screen.dart';
import '../utils/extension/context_extension.dart';

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
  initialLocation: AppRouter.geminiAi,
  routes: [
    GoRoute(
      path: AppRouter.geminiAi,
      name: AppRouter.geminiAi,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (BuildContext context) {
              return GeminiAiBloc(
                homeRepository: context.dependency.geminiAiRepository,
              );
            },
            child: const GeminiAiScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
  ],
);
