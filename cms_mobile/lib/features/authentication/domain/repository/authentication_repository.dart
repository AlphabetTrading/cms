import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/authentication/domain/entities/login_entity.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/authentication/domain/usecases/authentication_usecase.dart';

abstract class AuthenticationRepository {
  Future<DataState<LoginEntity>> login({required LoginParams loginParams});

  Future<DataState<LoginEntity>> logout();

  Future<DataState<UserEntity>> getUser();

  Future<bool> isSignedIn();
}
