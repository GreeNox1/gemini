import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/model/video_model.dart';
import '../../../common/router/app_router.dart';
import '../controller/play_video_controller.dart';

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
      appBar: AppBar(
        title: Text(widget.video.text.split("/").last),
        leading: IconButton(
          onPressed: () {
            context.pop(AppRouter.videoListVideoPlayer);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child:
                    chewieController.videoPlayerController.value.isInitialized
                        ? AspectRatio(
                          aspectRatio:
                              chewieController
                                  .videoPlayerController
                                  .value
                                  .aspectRatio,
                          child: Chewie(controller: chewieController),
                        )
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
      ),
    );
  }
}
