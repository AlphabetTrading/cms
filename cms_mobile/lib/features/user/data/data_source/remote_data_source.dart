import 'package:graphql_flutter/graphql_flutter.dart';

abstract class UserDataSource {
  // Future<DataState<String>> createUser(
  //     {required CreateUserParamsModel createUserParamsModel});

  // Future<DataState<UserModelListWithMeta>> getUsers(
  //     {required GetUsersParamsEntity params});

  // Future<DataState<UserModel>> getUserDetails(
  //     {required String params});

  // Future<DataState<String>> editUser(
  //     {required EditUserParamsModel editUserParamsModel});

  // Future<DataState<String>> deleteUser({required String userId});
}

class UserDataSourceImpl extends UserDataSource {
  late final GraphQLClient _client;
// Define the mutation
  UserDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createUserMutation = r'''
mutation CreateUser($createUserInput: CreateUserInput!) {
  createUser(createUserInput: $createUserInput) {
    id
  }
}

  ''';

  static const String _deleteUserMutation = r'''
mutation DeleteUser($deleteUserId: String!) {
  deleteUser(id: $deleteUserId) {
    id
  }
}
''';

  static const String _editUserMutation = r'''
mutation UpdateUser($updateUserInput: UpdateUserInput!) {
  updateUser(updateUserInput: $updateUserInput) {
    id
  }
}
''';

  // Override the function in the implementation class
  // @override
  // Future<DataState<String>> createUser(
  //     {required CreateUserParamsModel createUserParamsModel}) async {
  //   final MutationOptions options = MutationOptions(
  //     document: gql(_createUserMutation),
  //     variables: {"createUserInput": createUserParamsModel.toJson()},
  //   );

  //   try {
  //     final QueryResult result = await _client.mutate(options);

  //     if (result.hasException) {
  //       return DataFailed(
  //           ServerFailure(errorMessage: result.exception.toString()));
  //     }

  //     // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
  //     final String id = result.data!['createUser']['id'];

  //     return DataSuccess(id);
  //   } catch (e) {
  //     // In case of any other errors, return a DataFailed state
  //     return DataFailed(ServerFailure(errorMessage: e.toString()));
  //   }
  // }

  // @override
  // Future<DataState<UserModelListWithMeta>> getUsers(
  //     {required GetUsersParamsEntity params}) {
  //   String fetchUsersQuery = r'''

  //   ''';

  //   return _client
  //       .query(QueryOptions(
  //     document: gql(fetchUsersQuery),
  //     fetchPolicy: FetchPolicy.networkOnly
    
  //     // variables: {"": params},
  //   ))
  //       .then((response) {
  //     if (response.hasException) {
  //       return DataFailed(
  //         ServerFailure(
  //           errorMessage: response.exception.toString(),
  //         ),
  //       );
  //     }
  //     final users =
  //         UserModelListWithMeta.fromJson(response.data!['getUsers']);

  //     return DataSuccess(users);
  //   });
  // }


  // @override
  // Future<DataState<UserModel>> getUserDetails(
  //     {required String params}) {
  //   String fetchUserDetailsQuery = r'''

  //   ''';

  //   return _client
  //       .query(QueryOptions(
  //     document: gql(fetchUserDetailsQuery),
  //     variables: {"getUserId": params},
  //   ))
  //       .then((response) {
  //     if (response.hasException) {
  //       return DataFailed(
  //         ServerFailure(
  //           errorMessage: response.exception.toString(),
  //         ),
  //       );
  //     }

  //     final user = UserModel.fromJson(response.data!['getUser']);

  //     return DataSuccess(user);
  //   });
  // }

  // @override
  // Future<DataState<String>> editUser(
  //     {required EditUserParamsModel editUserParamsModel}) async {
  //   final MutationOptions options = MutationOptions(
  //     document: gql(_editUserMutation),
  //     variables: {"updateUserInput": editUserParamsModel.toJson()},
  //   );

  //   try {
  //     final QueryResult result = await _client.mutate(options);

  //     if (result.hasException) {
  //       return DataFailed(
  //           ServerFailure(errorMessage: result.exception.toString()));
  //     }

  //     // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
  //     final String id = result.data!['updateUser']['id'];

  //     return DataSuccess(id);
  //   } catch (e) {
  //     // In case of any other errors, return a DataFailed state
  //     return DataFailed(ServerFailure(errorMessage: e.toString()));
  //   }
  // }

  // @override
  // Future<DataState<String>> deleteUser(
  //     {required String userId}) async {
  //   final MutationOptions options = MutationOptions(
  //     document: gql(_deleteUserMutation),
  //     variables: {"deleteUserId": userId},
  //   );

  //   try {
  //     final QueryResult result = await _client.mutate(options);

  //     if (result.hasException) {
  //       return DataFailed(
  //           ServerFailure(errorMessage: result.exception.toString()));
  //     }

  //     // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
  //     final String id = result.data!['deleteUser']['id'];

  //     return DataSuccess(id);
  //   } catch (e) {
  //     // In case of any other errors, return a DataFailed state
  //     return DataFailed(ServerFailure(errorMessage: e.toString()));
  //   }
  // }
}
