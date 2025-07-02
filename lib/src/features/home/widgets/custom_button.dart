import 'package:flutter/gestures.dart';
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
  late final ValueNotifier<bool> _isSelected;
  late final LongPressGestureRecognizer _longPressGestureRecognizer;
  late final TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _isSelected = ValueNotifier(false);
    _longPressGestureRecognizer = LongPressGestureRecognizer(
      debugOwner: this,
      duration: Duration(microseconds: 5),
    );
    _tapGestureRecognizer = TapGestureRecognizer(debugOwner: this);
  }

  void _onChanged({bool newSelected = true}) {
    if (newSelected != _isSelected.value) {
      _isSelected.value = !_isSelected.value;
    }
  }

  @override
  void dispose() {
    _isSelected.dispose();
    _longPressGestureRecognizer.dispose();
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSize.paddingAll10,
      child: ValueListenableBuilder(
        valueListenable: _isSelected,
        builder: (context, isSelected, child) {
          return RawGestureDetector(
            gestures: {
              TapGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                    () => _tapGestureRecognizer,
                    (instance) {
                      instance.onTap = () => widget.onPressed!();
                    },
                  ),
              LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                LongPressGestureRecognizer
              >(() => _longPressGestureRecognizer, (instance) {
                instance
                  ..onLongPress = () {
                    _onChanged();
                  }
                  ..onLongPressMoveUpdate = (_) {
                    _onChanged(newSelected: false);
                  }
                  ..onLongPressEnd = (_) {
                    if (isSelected) {
                      widget.onPressed!();
                    }
                  };
              }),
            },
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: context.colors.secondary,
                borderRadius: AppSize.borderRadiusAll18,
              ),
              duration: Duration(milliseconds: 180),
              height: isSelected ? 60 : 70,
              curve: Curves.easeInOutSine,
              child: child,
            ),
          );
        },
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
    );
  }
}
