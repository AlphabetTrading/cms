import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class UserDataSource {
  Future<DataState<List<UserModel>>> fetchUsers({
    FilterUserInput? filterUserInput,
  });

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

  @override
  Future<DataState<List<UserModel>>> fetchUsers({
    FilterUserInput? filterUserInput,
  }) async {
    String fetchUsersQuery;

    fetchUsersQuery = r'''
      query GetUsers($filterUserInput: FilterUserDocumentsInput) {
        getUsers(filterUserInput: $filterUserInput) {
          id
          fullName
          phoneNumber
          email
          role
          company {
            id
            name
            address
            contactInfo
            createdAt
            ownerId
            owner {
              id
              fullName
              email
              phoneNumber
              role
              createdAt
            }
            employees {
              id
              fullName
              email
              phoneNumber
              role
              createdAt
              updatedAt
            }
            projects {
              id
              name
              budget
              createdAt
              endDate
              startDate
              status
              updatedAt
              companyId
            }
            warehouseStores {
              companyId
              createdAt
              id
              location
              name
              updatedAt
            }
          }
        }
      }
    ''';

    dynamic filterInput = filterUserInput!.toJson();
    return _client
        .query(
      QueryOptions(
        document: gql(fetchUsersQuery),
        variables: {
          'filterUserInput': filterInput,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    )
        .then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      final users = response.data!['getUsers'] as List;
      final items = users.map((e) => UserModel.fromJson(e)).toList();

      return DataSuccess(items);
    });
  }
}

class FilterUserInput {
  final StringFilter? id;
  final StringFilter? company;
  final StringFilter? fullName;
  final StringFilter? email;
  final StringFilter? phoneNumber;
  final List<String>? role;
  final StringFilter? createdAt;

  FilterUserInput(
      {this.createdAt,
      this.company,
      this.email,
      this.id,
      this.fullName,
      this.phoneNumber,
      this.role});

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id!.toJson(),
      if (fullName != null) 'fullName': fullName!.toJson(),
      if (email != null) 'email': email!.toJson(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber!.toJson(),
      if (role != null) 'role': role,
      if (company != null)
        'company': {
          'name': company!.toJson(),
        },
    };
  }
}
