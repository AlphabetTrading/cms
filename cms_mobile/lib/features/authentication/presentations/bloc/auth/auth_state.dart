part of 'auth_bloc.dart';

enum AuthStatus {
  loading,
  success,
  failed,
  user,
  signedIn,
  signedOut,
}

class AuthState extends Equatable {
  final AuthStatus? status;
  final UserEntity? user;

  const AuthState({this.status, this.user});

  @override
  List<Object?> get props => [
        status,
        user,
      ];
}

// class AuthInitial extends AuthState {}

// class AuthSuccess extends AuthState {
//   const AuthSuccess();
// }

// class AuthFailed extends AuthState {
//   const AuthFailed();
// }

// class AuthLoading extends AuthState {
//   const AuthLoading();
// }

// class AuthUser extends AuthState {
//   @override
//   final UserEntity user;

//   const AuthUser(
//     this.user,
//   );
// }

// class AuthSignedIn extends AuthState {
//   @override
//   final UserEntity user;
//   @override
//   final AuthStatus status;

//   @override
//   const AuthSignedIn({
//     required this.user,
//     required this.status,
//   }) : super(status: status, user: user);
// }

// class AuthSignedOut extends AuthState {
//   const AuthSignedOut();
// }

// class AuthError extends AuthState {
//   final String message;

//   const AuthError(this.message);
// }
