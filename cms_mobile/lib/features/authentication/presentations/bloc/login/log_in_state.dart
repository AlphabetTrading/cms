part of 'log_in_bloc.dart';

enum LoginStatus {
  loading,
  loaded,
  error,
}

abstract class LoginFormState extends Equatable {
  const LoginFormState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginFormState {}

class LoginLoading extends LoginFormState {}

class LoginSuccess extends LoginFormState {}

class LoginFailed extends LoginFormState {
  final String errorMessage;
  const LoginFailed({
    required this.errorMessage,
  });
  
}
