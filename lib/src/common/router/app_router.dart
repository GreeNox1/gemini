import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/gemini_ai/bloc/gemini_ai_bloc.dart';
import '../../features/gemini_ai/screen/gemini_ai_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/second_screen.dart';
import '../../features/underground_railway/screens/railway_screen.dart';
import '../../features/video_player/bloc/video_player_bloc.dart';
import '../../features/video_player/model/video_model.dart';
import '../../features/video_player/screens/folders.dart';
import '../../features/video_player/screens/permission.dart';
import '../../features/video_player/screens/play_video.dart';
import '../../features/video_player/screens/video_list.dart';
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
  initialLocation: AppRouter.permission,
  routes: [
    GoRoute(
      path: AppRouter.permission,
      name: AppRouter.permission,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: BlocProvider(
            create: (BuildContext context) {
              return VideoPlayerBloc(
                videoPlayerRepository: context.dependency.videoPlayerRepository,
              )..add(CheckPermission$VideoPlayerEvent(context: context));
            },
            child: PermissionScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: AppRouter.foldersVideoPlayer,
      name: AppRouter.foldersVideoPlayer,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) {
              return VideoPlayerBloc(
                videoPlayerRepository: context.dependency.videoPlayerRepository,
              )..add(GetVideoAll$VideoPlayerEvent(context: context));
            },
            child: Folders(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: AppRouter.videoListVideoPlayer,
      name: AppRouter.videoListVideoPlayer,
      pageBuilder: (context, state) {
        Map<String, Object> map = state.extra as Map<String, Object>;
        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) {
              return VideoPlayerBloc(
                videoPlayerRepository: context.dependency.videoPlayerRepository,
              )..add(GetVideoAll$VideoPlayerEvent(context: context));
            },
            child: VideoList(
              directoryTitle: map["title"] as String,
              directoryId: map["id"] as int,
              videos: map["videos"] as VideoModel,
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: AppRouter.playVideoPlayer,
      name: AppRouter.playVideoPlayer,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: PlayVideo(video: state.extra as VideoDataModel),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
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
