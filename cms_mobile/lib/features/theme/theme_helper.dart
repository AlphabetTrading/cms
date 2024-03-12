import 'dart:ui';

import 'package:cms_mobile/core/app_export.dart';
import 'package:flutter/material.dart';

class ThemeHelper {
  static const String LIGHT_THEME = 'light';
  static const String DARK_THEME = 'dark';
  static const String SYSTEM_THEME = 'system';
  static const String THEME_KEY = 'theme';

  var _appTheme = PrefUtils().getThemeData();

  Map<String, PrimaryColors> _primaryColors = {
    LIGHT_THEME: PrimaryColors(
      primary: Color(0xFF6200EE),
      primaryVariant: Color(0xFF3700B3),
      secondary: Color(0xFF03DAC6),
      secondaryVariant: Color(0xFF018786),
      background: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      error: Color(0xFFB00020),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
      onBackground: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      onError: Color(0xFFFFFFFF),
    ),
    DARK_THEME: PrimaryColors(
      primary: Color(0xFFBB86FC),
      primaryVariant: Color(0xFF3700B3),
      secondary: Color(0xFF03DAC6),
      secondaryVariant: Color(0xFF018786),
      background: Color(0xFF121212),
      surface: Color(0xFF121212),
      error: Color(0xFFCF6679),
      onPrimary: Color(0xFF000000),
      onSecondary: Color(0xFF000000),
      onBackground: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      onError: Color(0xFF000000),
    ),
    SYSTEM_THEME: PrimaryColors(
      primary: Color(0xFF6200EE),
      primaryVariant: Color(0xFF3700B3),
      secondary: Color(0xFF03DAC6),
      secondaryVariant: Color(0xFF018786),
      background: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      error: Color(0xFFB00020),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
      onBackground: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      onError: Color(0xFFFFFFFF),
    ),
  };

  ThemeData getTheme() {
    return ThemeData(
      primaryColor: _primaryColors[_appTheme]!.primary,
      primaryColorDark: _primaryColors[_appTheme]!.primaryVariant,
      scaffoldBackgroundColor: _primaryColors[_appTheme]!.surface,
      colorScheme: ColorScheme(
        primary: _primaryColors[_appTheme]!.primary,
        secondary: _primaryColors[_appTheme]!.secondary,
        background: _primaryColors[_appTheme]!.background,
        surface: _primaryColors[_appTheme]!.surface,
        error: _primaryColors[_appTheme]!.error,
        onPrimary: _primaryColors[_appTheme]!.onPrimary,
        onSecondary: _primaryColors[_appTheme]!.onSecondary,
        onBackground: _primaryColors[_appTheme]!.onBackground,
        onSurface: _primaryColors[_appTheme]!.onSurface,
        onError: _primaryColors[_appTheme]!.onError,
        brightness: Brightness.light,
      ),
    );
  }
}

class PrimaryColors {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color background;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;

  PrimaryColors({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.background,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
  });
}
