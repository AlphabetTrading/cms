import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String id;
  final String accessToken;
  final String refreshToken;

  const LoginEntity({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [id, accessToken, refreshToken];
}
