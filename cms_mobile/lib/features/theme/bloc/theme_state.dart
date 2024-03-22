// part of 'theme_bloc.dart';

// @immutable
// class ThemeState extends Equatable {
//   const ThemeState({required this.themeType});

//   final String themeType;

//   @override
//   List<Object> get props => [themeType];

//   ThemeState copyWith({
//     String? themeType,
//   }) {
//     return ThemeState(
//       themeType: themeType ?? this.themeType,
//     );
//   }
// }

import 'package:cms_mobile/features/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final ThemeData themeData;

  ThemeState(this.themeData);

  static ThemeState get darkTheme => ThemeState(DARK_THEME);

  static ThemeState get lightTheme => ThemeState(LIGHT_THEME);
}
