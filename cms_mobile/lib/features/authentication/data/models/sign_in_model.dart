import 'package:cms_mobile/features/authentication/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    required super.id,
    required super.accessToken,
    required super.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['userId'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
