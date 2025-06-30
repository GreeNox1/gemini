import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../common/style/app_videos.dart';
import '../screens/railway_screen.dart';

mixin RailwayController on State<UndergroundRailwayScreen> {
  List<String> mapRailwaysInFirst = [
    "Yangihayot",
    "Sergeli",
    "O'zgarish",
    "Chostepa",
    "Olmazor",
    "Chilonzor",
    "Mirzo Ulug'bek",
    "Novza",
    "Milliy bog'",
    "Xalqlar do'stligi",
    "Paxtakor",
    "Mustaqillik Maydoni",
    "Amir temur xiyoboni",
    "Hamid Olimjon",
    "Pushkin",
    "Buyuk ipak yo'li",
  ];

  List<String> changeRailways = [
    "Yangihayot",
    "Paxtakor",
    "Amir temur xiyoboni",
  ];

  int station = 0;
  bool isAnimation = false;

  late final ScrollController scrollController;
  late final VideoPlayerController videoPlayerController;
  late Timer? timer;
  bool isClickButton = false;

  void goTo(int index) async {
    if (isAnimation || isClickButton) return;

    await videoAnimation(index);

    setState(() {
      station = index;
    });

    scrollController.animateTo(
      index * 460.0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> videoAnimation(int index) async {
    if (station < index) {
      setState(() {
        isAnimation = true;
        isClickButton = true;
      });
    }

    if (isAnimation || isClickButton) {
      Future.delayed(Duration(seconds: 6), () {
        isClickButton = false;
      });

      timer = Timer(Duration(seconds: 3), () {
        setState(() {
          isAnimation = false;
        });
      });

      videoPlayerController.play();
    }

    await Future.delayed(Duration(seconds: 4));
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.asset(AppVideos.closingDoor)
          ..setVolume(0)
          ..initialize().then((_) => setState(() {}));
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    scrollController.dispose();
  }
}
