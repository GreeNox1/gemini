import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/video_player_bloc.dart';
import '../screens/video_list.dart';

mixin VideoListController on State<VideoList> {
  late final MenuController controller;
  late final VideoPlayerBloc bloc;
  int? selected;

  @override
  void initState() {
    super.initState();
    bloc = context.read<VideoPlayerBloc>();
    controller = MenuController();
  }

  @override
  void dispose() {
    bloc.close();
    controller.close();
    super.dispose();
  }
}
