import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';
import 'package:udevs/src/features/video_player/bloc/video_player_bloc.dart';
import 'package:udevs/src/features/video_player/controller/video_list_controller.dart';
import 'package:udevs/src/features/video_player/model/video_model.dart';
import 'package:udevs/src/features/video_player/screens/play_video.dart';
import 'package:udevs/src/features/video_player/widgets/video_button.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key, required this.videoModel});

  final VideoModel videoModel;

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
          widget.videoModel.fileName,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
        builder:
            (context, state) => ListView.builder(
              itemCount: widget.videoModel.videos.length,
              itemBuilder: (context, index) {
                VideoDataModel video = widget.videoModel.videos[index];
                return VideoButton(
                  title: video.text.split("/").last,
                  image: video.uint8list,
                  duration: video.duration,
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayVideo(video: video),
                        ),
                      ),
                  onPressedDownload: () {
                    context.read<VideoPlayerBloc>().add(
                      DownloadVideo$VideoPlayerEvent(
                        context: context,
                        url: video.urlVideo ?? "",
                        index: index,
                      ),
                    );
                  },
                  onPressedRemove: () {
                    context.read<VideoPlayerBloc>().add(
                      DeleteVideo$VideoPlayerEvent(
                        context: context,
                        path: video.text,
                      ),
                    );
                    Navigator.maybePop(context);
                    context.read<VideoPlayerBloc>().add(
                      UpdateVideo$VideoPlayerEvent(context: context),
                    );
                  },
                  onPressedPause: () {
                    context.read<VideoPlayerBloc>().add(
                      PauseVideo$VideoPlayerEvent(context: context),
                    );
                  },
                  isDownload: !state.isDownload,
                  videoUrl: video.urlVideo,
                  download: state.download,
                  progress: state.progress,
                  isVideoDownload: state.videoIndex == index,
                );
              },
            ),
      ),
    );
  }
}
