import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/authentication/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/authentication/domain/entities/login_entity.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/authentication/domain/repository/authentication_repository.dart';

class IsSignedInUseCase implements UseCaseWithoutState<AuthData, void> {
  final AuthenticationRepository _authenticationRepository;

  IsSignedInUseCase(this._authenticationRepository);

  @override
  Future<AuthData> call({void params}) {
    return _authenticationRepository.isSignedIn();
  }
}

class LogoutUseCase implements UseCase<LoginEntity, void> {
  final AuthenticationRepository _authenticationRepository;

  LogoutUseCase(this._authenticationRepository);

  @override
  Future<DataState<LoginEntity>> call({void params}) {
    return _authenticationRepository.logout();
  }
}

class LoginUseCase implements UseCase<LoginEntity, LoginParams> {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  @override
  Future<DataState<LoginEntity>> call({LoginParams? params}) {
    return _authenticationRepository.login(loginParams: params!);
  }
}

class GetUserUseCase implements UseCase<UserEntity, void> {
  final AuthenticationRepository _authenticationRepository;

  GetUserUseCase(this._authenticationRepository);

  @override
  Future<DataState<UserEntity>> call({void params}) {
    return _authenticationRepository.getUser();
  }
}

class LoginParams {
  String password;
  String phoneNumber;

  LoginParams({
    required this.password,
    required this.phoneNumber,
  });
}
