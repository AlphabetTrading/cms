import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData baseTheme = ThemeData(
  fontFamily:GoogleFonts.inter().fontFamily,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18),
  ),
);

ThemeData DARK_THEME = baseTheme.copyWith(
  brightness: Brightness.dark,
  textTheme: baseTheme.textTheme.copyWith(
    bodyLarge: const TextStyle(color: Colors.black87),
  ),
  appBarTheme: baseTheme.appBarTheme.copyWith(
    backgroundColor: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  primaryColor: Color(0xFFBB86FC),
  primaryColorDark: Color(0xFFBB86FC),
  scaffoldBackgroundColor: Color(0xFF121212),
  colorScheme: const ColorScheme(
    primary: Color(0xFFBB86FC),
    secondary: Color(0xFF03DAC6),
    background: Color(0xFF121212),
    surface: Color(0xFF121212),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    onError: Color(0xFF000000),
    brightness: Brightness.dark,
  ),
);

ThemeData LIGHT_THEME = baseTheme.copyWith(
  brightness: Brightness.light,
  textTheme: baseTheme.textTheme.copyWith(
    bodyLarge: const TextStyle(color: Colors.white70),
  ),
  appBarTheme: baseTheme.appBarTheme.copyWith(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  primaryColor: Color(0xFF6200EE),
  primaryColorDark: Color(0xFF6200EE),
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  colorScheme: const ColorScheme(
    primary: Color(0xFF6200EE),
    secondary: Color(0xFF03DAC6),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFF000000),
    onSurface: Color(0xFF000000),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  ),
);
