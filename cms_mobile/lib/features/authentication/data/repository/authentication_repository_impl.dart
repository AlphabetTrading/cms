import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/authentication/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/authentication/domain/entities/login_entity.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/authentication/domain/repository/authentication_repository.dart';
import 'package:cms_mobile/features/authentication/domain/usecases/authentication_usecase.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationRemoteDataSource dataSource;

  AuthenticationRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<LoginEntity>> login({required LoginParams loginParams}) {
    return dataSource.login(loginParams);
  }

  @override
  Future<DataState<UserEntity>> getUser() async {
    return dataSource.getUser();
  }

  @override
  Future<AuthData> isSignedIn() {
    return dataSource.isSignedIn();
  }

  @override
  Future<DataState<LoginEntity>> logout() {
    return dataSource.logout();
  }
}
