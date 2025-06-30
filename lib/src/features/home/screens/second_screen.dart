import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/router/app_router.dart';
import '../../../common/utils/extension/context_extension.dart';
import '../../../common/widgets/custom_button.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Screen")),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 90,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        context.go(AppRouter.undergroundRailway);
                      },
                      child: Center(
                        child: Text(
                          "Railway",
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 90,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        context.go(AppRouter.home);
                      },
                      child: Center(
                        child: Text(
                          "Home Screen",
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        context.go(AppRouter.geminiAi);
                      },
                      child: Center(
                        child: Text(
                          context.lang.gemini_ai,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
