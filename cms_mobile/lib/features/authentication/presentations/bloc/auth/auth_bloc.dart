import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  IsSignedInUseCase isSignedInUseCase;
  LogoutUseCase logoutUseCase;
  GetUserUseCase getUserUseCase;

  AuthBloc({
    required this.isSignedInUseCase,
    required this.logoutUseCase,
    required this.getUserUseCase,
  }) : super(const AuthState(
          status: AuthStatus.loading,
          user: null,
        )) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthGetUser>(_onAuthGetUser);
    on<AuthIsSignedIn>(_onAuthIsSignedIn);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState(
      status: AuthStatus.loading,
      user: null,
    ));

    final isSignedIn = await isSignedInUseCase();
    if (isSignedIn) {
      emit(const AuthState(
        status: AuthStatus.signedIn,
        user: null,
      ));
    } else {
      emit(
        const AuthState(
          status: AuthStatus.signedOut,
          user: null,
        ),
      );
    }
  }

  void _onAuthLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
    emit(const AuthState(
      status: AuthStatus.loading,
    ));
    final isSignedOut = await logoutUseCase();

    if (isSignedOut.data != null) {
      emit(const AuthState(
        status: AuthStatus.signedOut,
      ));
    } else {
      emit(
        const AuthState(
          status: AuthStatus.failed,
        ),
      );
    }
  }

  void _onAuthGetUser(AuthGetUser event, Emitter<AuthState> emit) async {
    emit(const AuthState(
      status: AuthStatus.loading,
    ));
    final dataState = await getUserUseCase();

    if (dataState is DataSuccess) {
      print("getinggg userrrrr");
      print(dataState.data);

      emit(
        AuthState(
          status: AuthStatus.user,
          user: dataState.data,
        ),
      );
    }

    if (dataState is DataFailed) {
      emit(
        const AuthState(
          status: AuthStatus.failed,
        ),
      );
    }
  }

  void _onAuthIsSignedIn(AuthIsSignedIn event, Emitter<AuthState> emit) async {
    emit(const AuthState(
      status: AuthStatus.loading,
    ));
    final isSignedIn = await isSignedInUseCase();
    if (isSignedIn) {
      emit(
        const AuthState(
          status: AuthStatus.signedIn,
        ),
      );
    } else {
      emit(const AuthState(
        status: AuthStatus.signedOut,
      ));
    }
  }
}
