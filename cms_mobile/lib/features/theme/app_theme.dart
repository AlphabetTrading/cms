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
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  dividerTheme: const DividerThemeData(
    thickness: 1,
    indent: 10,
    endIndent: 10,
  ),
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 14),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // Specify the color for the disabled state
          }
          return Color(0xFF1A80E5); // Use the default value for other states
        },
      ),

      // MaterialStateProperty.all<Color>(Color(0xFF1A80E5)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      elevation: MaterialStateProperty.all(0),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      foregroundColor: MaterialStateProperty.all(Color(0xFF1A80E5)),
      side: MaterialStateProperty.all(BorderSide(
        color: Color(0xFF1A80E5),
      )),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFEAECEF),
    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    labelStyle: TextStyle(
      color: Colors.grey[800],
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: TextStyle(
      color: Colors.grey[800],
      fontSize: 16,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFEAECEF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
    ).copyWith(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    ),
  ),
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
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Color(0xFF1A80E5),
    unselectedItemColor: Color(0xff637587),
  ),
  textTheme: baseTheme.textTheme.copyWith(
    displaySmall:
        baseTheme.textTheme.displaySmall?.copyWith(color: Colors.white),
    bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(color: Colors.white),
    bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(color: Colors.white),
    labelSmall: baseTheme.textTheme.labelSmall
        ?.copyWith(color: Color.fromARGB(255, 171, 191, 212)),
    labelMedium: baseTheme.textTheme.labelMedium
        ?.copyWith(color: Color.fromARGB(255, 171, 191, 212)),
    labelLarge: baseTheme.textTheme.labelLarge
        ?.copyWith(color: Color.fromARGB(255, 171, 191, 212)),
  ),
  dividerTheme: baseTheme.dividerTheme.copyWith(color: Color(0x1A5CAEFF)),
  appBarTheme: baseTheme.appBarTheme.copyWith(
    backgroundColor: Color(0xFF121212),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  primaryColor: Color(0xFF1A80E5),
  // primaryColorDark: Color(0xFFBB86FC),
  scaffoldBackgroundColor: Color(0xFF121212),
  colorScheme: const ColorScheme(
    primaryContainer: Color(0x1A1A80E5),
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

  listTileTheme: baseTheme.listTileTheme.copyWith(
    titleTextStyle:
        baseTheme.listTileTheme.titleTextStyle?.copyWith(color: Colors.black),
    subtitleTextStyle: baseTheme.listTileTheme.subtitleTextStyle
        ?.copyWith(color: Color(0xFF637587)),
    leadingAndTrailingTextStyle: baseTheme
        .listTileTheme.leadingAndTrailingTextStyle
        ?.copyWith(color: Colors.black),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  ),

  textTheme: baseTheme.textTheme.copyWith(
    displaySmall:
        baseTheme.textTheme.displaySmall?.copyWith(color: Colors.black),
    bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(color: Colors.black),
    bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(color: Colors.black),
    labelSmall:
        baseTheme.textTheme.labelSmall?.copyWith(color: Color(0xFF637587)),
    labelMedium:
        baseTheme.textTheme.labelMedium?.copyWith(color: Color(0xFF637587)),
    labelLarge:
        baseTheme.textTheme.labelLarge?.copyWith(color: Color(0xFF637587)),
  ),

  appBarTheme: baseTheme.appBarTheme.copyWith(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Color(0xFF637587)),
  ),
  dividerTheme: baseTheme.dividerTheme.copyWith(color: Color(0xffC2D2E2)),
  primaryColor: Color(0xFF1A80E5),
  // primaryColorDark: Color(0xFF6200EE),
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  colorScheme: const ColorScheme(
    primaryContainer: Color(0x1A1A80E5),
    primary: Color(0xFF1A80E5),
    secondary: Color(0xFF03DAC6),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0x12104A84),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF121212),
    onBackground: Color(0xFF000000),
    onSurface: Color(0xFF121212),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  ),
);
