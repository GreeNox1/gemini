import 'dart:async';

import 'package:flutter/material.dart';

import '../screens/folders.dart';

mixin FoldersController on State<Folders> {
  bool isRefresh = false;

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
  }

  @override
  void dispose() {
    super.dispose();
  }
}
