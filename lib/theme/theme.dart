import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF7CB342),
    onPrimary: Color(0xFFF2F2F2),
    secondary: Color(0xFF9CCC65),
    onSecondary: Color(0xFFF2F2F2),
    tertiary: Color(0xFFE8F5E9),
    onTertiary: Color(0xFF1B5E20),
    error: Color(0xFFee6055),
    onError: Color(0xFFfff0f3),
    surface: Color(0xFFf8f9fa),
    onSurface: Color(0xFF333533),
    outline: Color(0xFFE0E0E0),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF6a994e),
    onPrimary: Color(0xFFF2F2F2),
    secondary: Color(0xFF6a994e),
    onSecondary: Color(0xFFF2F2F2),
    tertiary: Color(0xFF1B3D1B),
    onTertiary: Color(0xFFE8F5E9),
    error: Color(0xFFee6055),
    onError: Color(0xFFfff0f3),
    surface: Color(0xFF242423),
    onSurface: Color(0xFFadb5bd),
    outline: Color(0xFF424242),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);

class NoTransitionBuilder extends PageTransitionsBuilder {
  const NoTransitionBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}