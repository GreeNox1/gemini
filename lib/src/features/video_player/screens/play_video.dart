import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:udevs/src/features/video_player/controller/play_video_controller.dart';
import 'package:udevs/src/features/video_player/model/video_model.dart';

class PlayVideo extends StatefulWidget {
  const PlayVideo({super.key, required this.video});

  final VideoDataModel video;

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> with PlayVideoController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.video.text)),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child:
                  chewieController.videoPlayerController.value.isInitialized
                      ? Chewie(controller: chewieController)
                      : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
