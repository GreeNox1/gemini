import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';
import 'package:udevs/src/features/underground_railway/screens/underground_railway.dart';

import '../../../common/router/app_router.dart';
import '../../../common/widgets/custom_button.dart';
import '../../gemini_ai/bloc/gemini_ai_bloc.dart';
import '../../gemini_ai/screen/gemini_ai_screen.dart';
import 'home_screen.dart';

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
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UndergroundRailway(),
                            settings: RouteSettings(
                              name: AppRouter.undergroundRailway,
                            ),
                          ),
                        );
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                            settings: RouteSettings(name: AppRouter.home),
                          ),
                        );
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider(
                                  create: (BuildContext context) {
                                    return GeminiAiBloc(
                                      homeRepository:
                                          context.dependency.geminiAiRepository,
                                    );
                                  },
                                  child: const GeminiAiScreen(),
                                ),
                            settings: RouteSettings(name: AppRouter.geminiAi),
                          ),
                        );
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
