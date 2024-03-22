import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData baseTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(fontSize: 14),
    subtitleTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
    leadingAndTrailingTextStyle: TextStyle(fontSize: 14),
  ),
  textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      labelSmall: TextStyle(
        fontSize: 12,
      ),
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
);

ThemeData DARK_THEME = baseTheme.copyWith(
  brightness: Brightness.dark,
  listTileTheme: baseTheme.listTileTheme.copyWith(
    titleTextStyle:
        baseTheme.listTileTheme.titleTextStyle?.copyWith(color: Colors.white),
    subtitleTextStyle: baseTheme.listTileTheme.subtitleTextStyle
        ?.copyWith(color: Color(0xff637587)),
    leadingAndTrailingTextStyle: baseTheme
        .listTileTheme.leadingAndTrailingTextStyle
        ?.copyWith(color: Colors.white),
  ),
  textTheme: baseTheme.textTheme.copyWith(
    displayLarge:
        baseTheme.textTheme.displayLarge?.copyWith(color: Colors.black),
    bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(color: Colors.black),
    bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(color: Colors.black),
    labelSmall: baseTheme.textTheme.labelSmall
        ?.copyWith(color: Color.fromARGB(255, 171, 191, 212)),
    labelMedium: baseTheme.textTheme.labelMedium
        ?.copyWith(color: Color.fromARGB(255, 171, 191, 212)),
    labelLarge: baseTheme.textTheme.labelLarge
        ?.copyWith(color: Color.fromARGB(255, 171, 191, 212)),
  ),
  appBarTheme: baseTheme.appBarTheme.copyWith(
    backgroundColor: Color(0xFF121212),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  primaryColor: Color(0xFF1A80E5),
  // primaryColorDark: Color(0xFFBB86FC),
  scaffoldBackgroundColor: Color(0xFF121212),
  colorScheme: const ColorScheme(
    primary: Color(0xFF1A80E5),
    secondary: Color(0xFF03DAC6),
    background: Color(0xFF121212),
    surface: Color(0xFF121212),
    surfaceVariant: Color(0x1A5CAEFF),
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
    displayLarge:
        baseTheme.textTheme.displayLarge?.copyWith(color: Colors.black),
    bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(color: Colors.black),
    bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(color: Colors.black),
    labelSmall:
        baseTheme.textTheme.labelSmall?.copyWith(color: Color(0xFF637587)),
    labelMedium:
        baseTheme.textTheme.labelMedium?.copyWith(color: Color(0xFF637587)),
    labelLarge:
        baseTheme.textTheme.labelLarge?.copyWith(color: Color(0xFF637587)),
  ),

  listTileTheme: baseTheme.listTileTheme.copyWith(
    titleTextStyle:
        baseTheme.listTileTheme.titleTextStyle?.copyWith(color: Colors.black),
    subtitleTextStyle: baseTheme.listTileTheme.subtitleTextStyle
        ?.copyWith(color: Color(0xFF637587)),
    leadingAndTrailingTextStyle: baseTheme
        .listTileTheme.leadingAndTrailingTextStyle
        ?.copyWith(color: Colors.black),
  ),
  appBarTheme: baseTheme.appBarTheme.copyWith(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Color(0xFF637587)),
  ),
  primaryColor: Color(0xFF1A80E5),
  // primaryColorDark: Color(0xFF6200EE),
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  colorScheme: const ColorScheme(
    primary: Color(0xFF1A80E5),
    secondary: Color(0xFF03DAC6),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0x1A104A84),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFF000000),
    onSurface: Color(0xFF000000),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  ),
);
