import 'package:flutter/material.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';

import '../../../common/style/app_size.dart';

class RailwayButton extends StatelessWidget {
  const RailwayButton({super.key, required this.onPressed, required this.icon});

  final void Function() onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(context.colors.secondaryFixed),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppSize.borderRadiusAll15),
        ),
      ),
    );
  }
}
