import 'package:flutter/material.dart';
import 'package:udevs/src/common/dependency/app_dependencies.dart';

class AppScope extends StatefulWidget {
  const AppScope({super.key, required this.dependencies, required this.child});

  final AppDependencies dependencies;
  final Widget child;

  @override
  State<AppScope> createState() => AppScopeState();
}

class AppScopeState extends State<AppScope> {
  late final AppDependencies dependencies;

  @override
  void initState() {
    super.initState();
    dependencies = widget.dependencies;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
