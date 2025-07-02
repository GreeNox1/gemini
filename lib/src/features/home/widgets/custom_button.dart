import 'package:flutter/material.dart';

import '../../../common/style/app_size.dart';
import '../../../common/utils/extension/context_extension.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key, this.onPressed, required this.child});

  final void Function()? onPressed;
  final Widget child;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isSelected = false;

  void onChanged({bool newSelected = true}) {
    if (newSelected != isSelected) {
      setState(() {
        debugPrint("Button changed: $isSelected");
        isSelected = !isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSize.paddingAll10,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapMove: (details) => onChanged(newSelected: false),
        onLongPress: onChanged,
        onLongPressStart: (details) => onChanged(),
        onLongPressUp: isSelected ? widget.onPressed : null,
        onLongPressMoveUpdate: (details) => onChanged(newSelected: false),
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: context.colors.secondary,
            borderRadius: AppSize.borderRadiusAll18,
          ),
          duration: Duration(milliseconds: 230),
          height: isSelected ? 60 : 70,
          curve: Curves.easeInOutSine,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.onSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(width: 3, color: Colors.transparent),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
