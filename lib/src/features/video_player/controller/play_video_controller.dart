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
      controller.initialize().then((value) => setState(() {}));
    } else {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.urlVideo ?? ""),
      );
      controller.initialize().then((value) => setState(() {}));
    }

    chewieController = ChewieController(
      videoPlayerController: controller,
      autoPlay: true,
      looping: true,
    );

    chewieController.setVolume(1);
    chewieController.play();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    if (controller.value.isInitialized) {
      controller.pause();
      controller.dispose();
    }
    chewieController.dispose();
    super.dispose();
  }
}
