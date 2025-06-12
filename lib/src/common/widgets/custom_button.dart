import 'package:flutter/material.dart';
import 'package:udevs/src/common/style/app_size.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key, required this.onPressed, required this.child});

  final void Function() onPressed;
  final Widget child;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isSelected = false;

  void onChanged({bool newSelected = true}) {
    if (newSelected != isSelected) {
      setState(() {
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
        onLongPress: onChanged,
        onLongPressUp: isSelected ? widget.onPressed : null,
        onLongPressMoveUpdate: (details) => onChanged(newSelected: false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: isSelected ? 60 : 70,
          curve: Curves.easeInOutSine,
          decoration: BoxDecoration(
            color: context.colors.onPrimary,
            borderRadius: AppSize.borderRadiusAll18,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.onPrimary,
              borderRadius: AppSize.borderRadiusAll18,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.surfaceTint,
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
      ),
    );
  }
}
