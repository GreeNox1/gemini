import 'dart:async';

import 'package:flutter/material.dart';

import '../screens/permission.dart';

mixin PermissionController on State<PermissionScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  void time({required void Function() permission}) {
    timer = Timer.periodic(Duration(seconds: 25), (_) => permission());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
