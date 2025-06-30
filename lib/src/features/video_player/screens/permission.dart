import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/router/app_router.dart';
import '../../../common/utils/extension/context_extension.dart';
import '../bloc/video_player_bloc.dart';
import '../controller/permission_controller.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with PermissionController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
        builder: (context, state) {
          if (!state.checkPermission) {
            time(
              permission: () {
                if (!mounted) return;

                context.read<VideoPlayerBloc>().add(
                  CheckPermission$VideoPlayerEvent(context: context),
                );
              },
            );
          } else {
            if (timer != null) {
              timer?.cancel();
              timer = null;
            }
          }

          if (state.checkPermission) {
            if (timer != null) {
              timer?.cancel();
              timer = null;
            }

            WidgetsBinding.instance.addPostFrameCallback(
              (_) => context.go(AppRouter.foldersVideoPlayer),
            );
          }

          return Center(
            child: CircularProgressIndicator(color: context.colors.onPrimary),
          );
        },
      ),
    );
  }
}
