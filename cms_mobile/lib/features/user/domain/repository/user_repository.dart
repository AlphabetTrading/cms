import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/user/data/data_source/remote_data_source.dart';

abstract class UserRepository {
  Future<DataState<List<UserModel>>> getUsers(
    FilterUserInput? filterUserInput,
  );
}
