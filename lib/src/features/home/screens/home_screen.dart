import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/router/app_router.dart';
import '../../../common/utils/extension/context_extension.dart';
import '../../../common/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")),
      bottomNavigationBar: SafeArea(
        child: CustomButton(
          onPressed: () {
            context.go(AppRouter.second);
          },
          child: Center(
            child: Text(
              "Second Screen",
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
