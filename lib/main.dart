import 'package:flutter/material.dart';
import 'package:udevs/src/common/widgets/app.dart';
import 'package:udevs/src/common/widgets/app_init.dart';
import 'package:udevs/src/common/widgets/app_scope.dart';

void main() async {
  final dependencies = await InitializeApp.initialize();

  runApp(AppScope(dependencies: dependencies, child: App()));
}
