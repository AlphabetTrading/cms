import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/user/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/user/domain/repository/user_repository.dart';

class GetUsersUseCase implements UseCase<List<UserModel>, UserParams?> {
  final UserRepository _userRepository;

  GetUsersUseCase(this._userRepository);

  @override
  Future<DataState<List<UserModel>>> call({UserParams? params}) {
    return _userRepository.getUsers(params!.filterUserInput);
  }
}

class UserParams {
  FilterUserInput? filterUserInput;

  UserParams({
    this.filterUserInput,
  });
}
