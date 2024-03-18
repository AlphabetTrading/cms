part of 'log_in_bloc.dart';

enum LoginStatus {
  loading,
  loaded,
  error,
}

// abstract class LoginState extends Equatable {
//   const LoginState({required LoginEntity login});

//   @override
//   List<Object> get props => [];
// }

// class LoginInitial extends LoginState {}

// class LoginLoading extends LoginState {}

// class LoginSuccess extends LoginState {}

// class LoginFailed extends LoginState {
//   final String errorMessage;
//   const LoginFailed({
//     required this.errorMessage,
//   });

// }

abstract class LoginState extends Equatable {
  final LoginEntity? login;
  final Failure? error;
  final LoginStatus? status;

  const LoginState({this.login, this.error, this.status});

  @override
  List<Object?> get props => [login, error, status];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess({required LoginEntity loginEntity})
      : super(login: loginEntity);
}

class LoginFailed extends LoginState {
  const LoginFailed({required Failure error}) : super(error: error);
}
