part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {}

class AuthLoggedOut extends AuthEvent {}

class AuthGetUser extends AuthEvent {
  final UserEntity user;

  AuthGetUser(this.user);
}

class AuthIsSignedIn extends AuthEvent {}


