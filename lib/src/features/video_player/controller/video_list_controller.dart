import 'package:flutter/material.dart';
import 'package:udevs/src/features/video_player/screens/video_list.dart';

mixin VideoListController on State<VideoList> {
  late final MenuController controller;
  int? selected;
  @override
  void initState() {
    super.initState();
    controller = MenuController();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
