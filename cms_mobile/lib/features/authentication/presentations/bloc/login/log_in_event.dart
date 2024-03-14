part of 'log_in_bloc.dart';

abstract class LoginFormEvent {
  const LoginFormEvent();
}

class LoginEvent extends LoginFormEvent {
  LoginParams loginParams;

  LoginEvent({
    required this.loginParams,
  });
}

