import 'package:flutter/material.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';
import 'package:udevs/src/features/home/screens/second_screen.dart';

import '../../../common/router/app_router.dart';
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SecondScreen(),
                settings: RouteSettings(name: AppRouter.second),
              ),
            );
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
