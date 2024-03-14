import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool get stringify => true;
}
