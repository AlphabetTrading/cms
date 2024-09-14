import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/data/models/milestone.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MilestoneDataSource {
  Future<DataState<String>> createMilestone(
      {required CreateMilestoneParamsModel createMilestoneParamsModel});
  Future<DataState<MilestoneModelListWithMeta>> getMilestones(
      {required GetMilestonesParamsEntity params});
  Future<DataState<MilestoneModel>> getMilestoneDetails(
      {required String params});
  Future<DataState<String>> editMilestone(
      {required EditMilestoneParamsModel editMilestoneParamsModel});
  Future<DataState<String>> deleteMilestone({required String milestoneId});
}

class MilestoneDataSourceImpl extends MilestoneDataSource {
  late final GraphQLClient _client;
// Define the mutation
  MilestoneDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createMilestoneMutation = r'''
mutation CreateMilestone($createMilestoneInput: CreateMilestoneInput!) {
  createMilestone(createMilestoneInput: $createMilestoneInput) {
    id
  }
}

  ''';

  static const String _deleteMilestoneMutation = r'''
mutation DeleteMilestone($deleteMilestoneId: String!) {
  deleteMilestone(id: $deleteMilestoneId) {
    id
  }
}
''';

  static const String _editMilestoneMutation = r'''
mutation UpdateMilestone($updateMilestoneInput: UpdateMilestoneInput!) {
  updateMilestone(updateMilestoneInput: $updateMilestoneInput) {
    id
  }
}
''';

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createMilestone(
      {required CreateMilestoneParamsModel createMilestoneParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createMilestoneMutation),
      variables: {"createMilestoneInput": createMilestoneParamsModel.toJson()},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['createMilestone']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<MilestoneModelListWithMeta>> getMilestones(
      {required GetMilestonesParamsEntity params}) {
    String fetchMilestonesQuery = r'''
query Items($filterMilestoneInput: FilterMilestoneInput, $paginationInput: PaginationInput, $orderBy: OrderByMilestoneInput) {
  getMilestones(filterMilestoneInput: $filterMilestoneInput, paginationInput: $paginationInput, orderBy: $orderBy) {
    items {
      id
      progress
      stage
      dueDate
      createdAt
      name
      description
      Tasks {
       id
       milestoneId
      }
      createdBy {
            fullName
        id
        email
        createdAt
        phoneNumber
        role
        updatedAt
      }
    }
    meta {
      count
      limit
      page
    }
  }
}
    ''';

    return _client
        .query(QueryOptions(
            document: gql(fetchMilestonesQuery),
            fetchPolicy: FetchPolicy.networkOnly

            // variables: {"": params},
            ))
        .then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }
      final materialIssue =
          MilestoneModelListWithMeta.fromJson(response.data!['getMilestones']);

      return DataSuccess(materialIssue);
    });
  }

  @override
  Future<DataState<MilestoneModel>> getMilestoneDetails(
      {required String params}) {
    String fetchMilestoneDetailsQuery = r'''
query GetMilestone($getMilestoneId: String!) {
  getMilestone(id: $getMilestoneId) {
    id
    name
    progress
    stage
    createdAt
    dueDate
    createdBy {
      createdAt
      email
      fullName
      id
      phoneNumber
      role
      updatedAt
    }
    description
    Tasks {
      assignedTo {
        id
        phoneNumber
        role
        fullName
        email
        createdAt
        updatedAt
      }
      milestoneId
      description
      dueDate
      id
      name
      priority
      status
      createdAt
    }
  }
}
    ''';

    return _client
        .query(QueryOptions(
            document: gql(fetchMilestoneDetailsQuery),
            variables: {"getMilestoneId": params},
            fetchPolicy: FetchPolicy.networkOnly))
        .then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      final milestone = MilestoneModel.fromJson(response.data!['getMilestone']);

      return DataSuccess(milestone);
    });
  }

  @override
  Future<DataState<String>> editMilestone(
      {required EditMilestoneParamsModel editMilestoneParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_editMilestoneMutation),
      variables: {"updateMilestoneInput": editMilestoneParamsModel.toJson()},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['updateMilestone']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<String>> deleteMilestone(
      {required String milestoneId}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_deleteMilestoneMutation),
      variables: {"deleteMilestoneId": milestoneId},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['deleteMilestone']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }
}
