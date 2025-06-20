import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:udevs/src/features/video_player/screens/folders.dart';

mixin FoldersController on State<Folders> {
  late Directory directory;
  bool isRefresh = false;

  void _permission() async {
    final responseAccessMediaLocation =
        await Permission.accessMediaLocation.request();
    final responseMediaLibrary = await Permission.mediaLibrary.request();
    final response = await Permission.manageExternalStorage.request();

    print("Access media location: ${responseAccessMediaLocation.isGranted}");
    print("Media Library: ${responseMediaLibrary.isGranted}");
    print("Response: ${response.isGranted}");
  }

  void timerFunction() async {
    isRefresh = true;
    Future.delayed(Duration(seconds: 20), () {
      isRefresh = false;
    });
  }

  @override
  void initState() {
    super.initState();

    timerFunction();

    _permission();
  }
}
