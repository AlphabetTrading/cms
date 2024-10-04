import 'package:cms_mobile/features/user/data/data_source/remote_data_source.dart';

abstract class UserEvent {
  const UserEvent();
}

class GetUsers extends UserEvent {
  final FilterUserInput? filterUserInput;
  const GetUsers({this.filterUserInput});
}

class GetUser extends UserEvent {
  final String id;
  const GetUser(this.id);
}

class CreateUser extends UserEvent {
  final String id;
  const CreateUser(this.id);
}

class UpdateUser extends UserEvent {
  final String id;
  const UpdateUser(this.id);
}

class DeleteUser extends UserEvent {
  final String id;
  const DeleteUser(this.id);
}
