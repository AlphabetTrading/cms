import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final List<UserEntity>? users;

  final Failure? error;

  const UserState({this.users, this.error});

  @override
  List<Object?> get props => [users, error];

  @override
  String toString() {
    return 'UserState { users: $users, error: $error}';
  }

  UserState copyWith({
    List<UserEntity>? users,
    Failure? error,
  }) {
    return UserState(
      users: users ?? this.users,
      error: error ?? this.error,
    );
  }
}

class UserInitial extends UserState {
  const UserInitial();
}

class UsersLoading extends UserState {
  const UsersLoading();
}

class UsersSuccess extends UserState {
  const UsersSuccess({required List<UserEntity> users}) : super(users: users);
}

class UsersFailed extends UserState {
  const UsersFailed({required Failure error}) : super(error: error);
}

class UsersEmpty extends UserState {
  const UsersEmpty();
}
