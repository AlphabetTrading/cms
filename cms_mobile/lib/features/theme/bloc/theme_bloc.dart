// import 'package:cms_mobile/core/utils/pref_utils.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'theme_event.dart';
// part 'theme_state.dart';

// class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
//   ThemeBloc({
//     required PrefUtils prefUtils,
//   }) : super(prefUtils.getThemeData() as ThemeState) {
//     on<ThemeChangeEvent>(_changeTheme);
//   }

//   _changeTheme(
//     ThemeChangeEvent event,
//     Emitter<ThemeState> emit,
//   ) async {
//     emit(state.copyWith(
//       themeType: event.themeType,
//     ));
//   }
// }

import 'package:cms_mobile/features/theme/bloc/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeEvent { toggleDark, toggleLight }

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.lightTheme) {
    // Handling the toggleDark event
    on<ThemeEvent>((event, emit) {
      if (event == ThemeEvent.toggleDark) {
        emit(ThemeState.darkTheme);
      } else if (event == ThemeEvent.toggleLight) {
        emit(ThemeState.lightTheme);
      }
    });
  }
}
