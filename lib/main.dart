import 'package:flutter/material.dart';

import 'src/common/widgets/app.dart';
import 'src/common/widgets/app_init.dart';
import 'src/common/widgets/app_scope.dart';

void main() async {
  final dependencies = await InitializeApp.initialize();

  runApp(AppScope(dependencies: dependencies, child: App()));
}
