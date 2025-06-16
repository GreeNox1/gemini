import 'package:flutter/material.dart';

class AppSize {
  const AppSize._();

  static const EdgeInsets paddingAll10 = EdgeInsets.all(10);
  static const EdgeInsets paddingAll20 = EdgeInsets.all(20);

  static const EdgeInsets paddingT40 = EdgeInsets.only(top: 40);

  static const EdgeInsets paddingV10 = EdgeInsets.symmetric(vertical: 10);

  static const EdgeInsets paddingV15H10 = EdgeInsets.symmetric(
    vertical: 15,
    horizontal: 10,
  );

  static const BorderRadius borderRadiusAll15 = BorderRadius.all(
    Radius.circular(15),
  );
  static const BorderRadius borderRadiusAll18 = BorderRadius.all(
    Radius.circular(18),
  );
  static const BorderRadius borderRadiusVer15 = BorderRadius.vertical(
    top: Radius.circular(15),
  );
}
