import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/router/app_router.dart';
import '../../../common/utils/extension/context_extension.dart';
import '../bloc/video_player_bloc.dart';
import '../controller/video_list_controller.dart';
import '../model/video_model.dart';
import '../widgets/video_button.dart';

class VideoList extends StatefulWidget {
  const VideoList({
    super.key,
    required this.directoryId,
    required this.directoryTitle,
    required this.videos,
  });

  final int directoryId;
  final String directoryTitle;
  final VideoModel videos;

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> with VideoListController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primary,
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        scrolledUnderElevation: 0,
        title: Text(
          widget.directoryTitle,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            bloc.add(PauseVideo$VideoPlayerEvent(context: context));
            context.go(AppRouter.foldersVideoPlayer);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
        builder: (context, state) {
          List<VideoDataModel> videos =
              state.videos.isEmpty
                  ? widget.videos.videos
                  : state.videos[widget.directoryId].videos;
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              VideoDataModel video = videos[index];
              return VideoButton(
                title: video.text.split("/").last,
                image: video.uint8list,
                duration: video.duration,
                onPressed: () {
                  context.push(AppRouter.playVideoPlayer, extra: video);
                },
                onPressedDownload: () {
                  bloc.add(
                    DownloadVideo$VideoPlayerEvent(
                      context: context,
                      url: video.urlVideo ?? "",
                      index: index,
                    ),
                  );
                },
                onPressedRemove: () {
                  bloc.add(
                    DeleteVideo$VideoPlayerEvent(
                      context: context,
                      path: video.text,
                    ),
                  );
                },
                onPressedPause: () {
                  bloc.add(PauseVideo$VideoPlayerEvent(context: context));
                },
                isDownload: !state.isDownload,
                videoUrl: video.urlVideo,
                download: state.download,
                progress: state.progress,
                isVideoDownload: state.videoIndex == index,
              );
            },
          );
        },
      ),
    );
  }
}
