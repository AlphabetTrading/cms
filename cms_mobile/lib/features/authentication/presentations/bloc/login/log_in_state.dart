part of 'log_in_bloc.dart';

enum LoginStatus {
  loading,
  loaded,
  error,
}

// abstract class LoginFormState extends Equatable {
//   const LoginFormState({required LoginEntity login});

//   @override
//   List<Object> get props => [];
// }

// class LoginInitial extends LoginFormState {}

// class LoginLoading extends LoginFormState {}

// class LoginSuccess extends LoginFormState {}

// class LoginFailed extends LoginFormState {
//   final String errorMessage;
//   const LoginFailed({
//     required this.errorMessage,
//   });

// }

abstract class LoginFormState extends Equatable {
  final LoginEntity? login;
  final Failure? error;
  final LoginStatus? status;

  const LoginFormState({this.login, this.error, this.status});

  @override
  List<Object?> get props => [login, error, status];
}

class LoginInitial extends LoginFormState {
  const LoginInitial();
}

class LoginLoading extends LoginFormState {
  const LoginLoading();
}

class LoginSuccess extends LoginFormState {
  const LoginSuccess({required LoginEntity loginEntity})
      : super(login: loginEntity);
}

class LoginFailed extends LoginFormState {
  const LoginFailed({required Failure error}) : super(error: error);
}
