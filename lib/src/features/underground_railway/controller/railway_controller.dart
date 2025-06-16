import 'dart:async';

import 'package:flutter/material.dart';
import 'package:udevs/src/common/style/app_assets.dart';
import 'package:udevs/src/features/underground_railway/screens/underground_railway.dart';
import 'package:video_player/video_player.dart';

mixin RailwayController on State<UndergroundRailway> {
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

    isClickButton = true;

    Future.delayed(Duration(seconds: 6), () {
      isClickButton = false;
    });

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
      });
    }

    if (isAnimation) {
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
        VideoPlayerController.asset(AppAssets.closingDoor)
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
