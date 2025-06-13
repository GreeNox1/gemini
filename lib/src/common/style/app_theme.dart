import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    fontFamily: "Poppins",
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    fontFamily: "Poppins",
  );
}

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xffffffff), // primary background
  onPrimary: Color(0xff2E2E5D), // primary text
  primaryContainer: Color(0xff4838D1), // primary container background
  onPrimaryContainer: Color(0xffffffff), // primary container text
  primaryFixed: Color(0xffdad7f6), // primary container focus background
  primaryFixedDim: Color(0xff6A6A8B), // light text
  onPrimaryFixed: Color(0xff010104), // dark text
  onPrimaryFixedVariant: Color(0xff200E32), // dark icon
  secondary: Color(0xfff87003), // secondary container background
  onSecondary: Color(0xfcf6911e), // secondary container
  secondaryContainer: Color(0xffF5F5FA),
  onSecondaryContainer: Color(0xff000000),
  secondaryFixed: Color(0xfffbd7c6),
  secondaryFixedDim: Color(0xfff4b292),
  onSecondaryFixed: Color(0xff5b2106),
  onSecondaryFixedVariant: Color(0xff6c2807),
  tertiary: Color(0xffbbb1fa),
  onTertiary: Color(0xff000000),
  tertiaryContainer: Color(0xffc5e7ff),
  onTertiaryContainer: Color(0xff000000),
  tertiaryFixed: Color(0xffc9e1f1),
  tertiaryFixedDim: Color(0xffa9d1e9),
  onTertiaryFixed: Color(0xff022032),
  onTertiaryFixedVariant: Color(0xff053f64),
  error: Color(0xffb00020),
  onError: Color(0xffffffff),
  errorContainer: Color(0xfffcd8df),
  onErrorContainer: Color(0xff000000),
  surface: Color(0xfff3f1fe),
  onSurface: Color(0xff111111),
  surfaceDim: Color(0xffe0e0e0),
  surfaceBright: Color(0xfffdfdfd),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xfff8f8f8),
  surfaceContainer: Color(0xfff3f3f3),
  surfaceContainerHigh: Color(0xffededed),
  surfaceContainerHighest: Color(0xffe7e7e7),
  onSurfaceVariant: Color(0xff393939),
  outline: Color(0xffb8b8c7),
  outlineVariant: Color(0xffd1d1d1),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff2a2a2a),
  onInverseSurface: Color(0xfff1f1f1),
  inversePrimary: Color(0xffa2d8ff),
  surfaceTint: Color(0xff095d9e),
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff0f0f29), // primary background
  onPrimary: Color(0xfff5f5fa), // primary text
  primaryContainer: Color(0xff4838D1), // primary container background
  onPrimaryContainer: Color(0xffffffff), // primary container text
  primaryFixed: Color(0xff2b237d), // primary container focus background
  primaryFixedDim: Color(0xffd5d5e3), // light text
  onPrimaryFixed: Color(0xfff5f5fa), // dark text
  onPrimaryFixedVariant: Color(0xffffffff), // dark icon
  secondary: Color(0xffF77A55), // secondary container background
  onSecondary: Color(0xffffffff), // secondary container text
  secondaryContainer: Color(0xff2e2e5d),
  onSecondaryContainer: Color(0xffffffff),
  secondaryFixed: Color(0xfffbd7c6),
  secondaryFixedDim: Color(0xfff4b292),
  onSecondaryFixed: Color(0xff5b2106),
  onSecondaryFixedVariant: Color(0xff6c2807),
  tertiary: Color(0xff9cd5f9),
  onTertiary: Color(0xff000000),
  tertiaryContainer: Color(0xff3a7292),
  onTertiaryContainer: Color(0xffffffff),
  tertiaryFixed: Color(0xffc9e1f1),
  tertiaryFixedDim: Color(0xffa9d1e9),
  onTertiaryFixed: Color(0xff022032),
  onTertiaryFixedVariant: Color(0xff053f64),
  error: Color(0xffcf6679),
  onError: Color(0xff000000),
  errorContainer: Color(0xffb1384e),
  onErrorContainer: Color(0xffffffff),
  surface: Color(0xff080808),
  onSurface: Color(0xfff1f1f1),
  surfaceDim: Color(0xff060606),
  surfaceBright: Color(0xff2c2c2c),
  surfaceContainerLowest: Color(0xff010101),
  surfaceContainerLow: Color(0xff0e0e0e),
  surfaceContainer: Color(0xff151515),
  surfaceContainerHigh: Color(0xff1d1d1d),
  surfaceContainerHighest: Color(0xff282828),
  onSurfaceVariant: Color(0xffcacaca),
  outline: Color(0xff777777),
  outlineVariant: Color(0xff414141),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffe8e8e8),
  onInverseSurface: Color(0xff2a2a2a),
  inversePrimary: Color(0xff253f52),
  surfaceTint: Color(0xff4585b5),
);
