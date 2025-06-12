import 'package:flutter/material.dart';
import 'package:udevs/src/common/style/app_size.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.text, this.isUser = true});

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return isUser
        ? Row(
          children: [
            Expanded(child: SizedBox()),
            Expanded(
              flex: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.inversePrimary,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: AppSize.paddingAll10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "You",
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(text, style: context.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
        : Row(
          children: [
            Expanded(
              flex: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.outline,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: AppSize.paddingAll10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gemini",
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(text, style: context.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.audiotrack),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        );
  }
}
