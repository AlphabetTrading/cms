import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/authentication/domain/entities/login_entity.dart';
import 'package:cms_mobile/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LoginBloc extends Bloc<LoginFormEvent, LoginState> {
  LoginUseCase logInUseCase;
  LoginBloc(this.logInUseCase) : super(const LoginInitial()) {
    on<LoginEvent>(_onLogin);
  }

  void _onLogin(LoginEvent event, Emitter<LoginState> emit) async {
    emit(const LoginLoading());
    debugPrint('DataState: started');

    final dataState = await logInUseCase(
      params: LoginParams(
        password: event.loginParams.password,
        phoneNumber: event.loginParams.phoneNumber,
      ),
    );

    debugPrint('DataState: ${dataState.data}');

    if (dataState is DataSuccess) {
      emit(LoginSuccess(loginEntity: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(LoginFailed(error: dataState.error!));
    }
  }
}
