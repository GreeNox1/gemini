import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/router/app_router.dart';
import '../../../common/style/app_icons.dart';
import '../../../common/utils/extension/context_extension.dart';
import '../bloc/video_player_bloc.dart';
import '../controller/folders_controller.dart';

class Folders extends StatefulWidget {
  const Folders({super.key});

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> with FoldersController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primary,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        elevation: 0,
        title: Text(
          context.lang.folders,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          if (!isRefresh) {
            context.read<VideoPlayerBloc>().add(
              UpdateVideo$VideoPlayerEvent(context: context),
            );
            timerFunction();
          }
        },
        color: Colors.blue,
        child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            return state.videos.isNotEmpty
                ? ListView(
                  children: [
                    for (int i = 0; i < state.videos.length; i++)
                      ListTile(
                        splashColor: context.colors.primary,
                        title: Text(
                          state.videos[i].fileName.split("/").last,
                          style: context.textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          "${state.videos[i].videos.length} Videos",
                        ),
                        leading: SvgPicture.asset(
                          AppIcons.folderIcon,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        onTap: () {
                          context.go(
                            AppRouter.videoListVideoPlayer,
                            extra: {
                              "title": state.videos[i].fileName.split("/").last,
                              "id": i,
                              "videos": state.videos[i],
                            },
                          );
                        },
                      ),
                  ],
                )
                : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,
                    children: [
                      CircularProgressIndicator(
                        color: context.colors.onPrimary,
                      ),
                      Text("Loading..."),
                    ],
                  ),
                );
          },
        ),
      ),
    );
  }
}
