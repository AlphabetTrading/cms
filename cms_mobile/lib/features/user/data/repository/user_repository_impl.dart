import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/user/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/user/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<List<UserModel>>> getUsers(
    FilterUserInput? filterUserInput,
  ) {
    return dataSource.fetchUsers(filterUserInput: filterUserInput);
  }
}
