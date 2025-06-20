import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../screens/play_video.dart';

mixin PlayVideoController on State<PlayVideo> {
  late final VideoPlayerController controller;
  late final ChewieController chewieController;
  int? bufferDelay;

  void _initVideoPlayer() async {
    if (widget.video.urlVideo == null) {
      controller = VideoPlayerController.file(File(widget.video.text));
      controller.initialize().then((_) => setState(() {}));
    } else {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.urlVideo ?? ""),
      );
      controller.initialize().then((_) => setState(() {}));
    }

    chewieController = ChewieController(
      videoPlayerController: controller,
      autoInitialize: true,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
    );

    // controller.play();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    controller.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
