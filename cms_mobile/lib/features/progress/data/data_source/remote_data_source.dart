import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
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
  Future<DataState<String>> deleteMilestone({required String materialIssueId});
}

class MilestoneDataSourceImpl extends MilestoneDataSource {
  late final GraphQLClient _client;
// Define the mutation
  MilestoneDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createMilestoneMutation = r'''


  ''';

  static const String _deleteMilestoneMutation = r'''
''';

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createMilestone(
      {required CreateMilestoneParamsModel createMilestoneParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createMilestoneMutation),
      variables: {
        // "createMilestoneInput": createMilestoneParamsModel.toJson()
      },
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
    ''';

    return _client
        .query(QueryOptions(
      document: gql(fetchMilestoneDetailsQuery),
      variables: {"getMilestoneByIdId": params},
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
          MilestoneModel.fromJson(response.data!['getMilestoneById']);

      return DataSuccess(materialIssue);
    });
  }

  @override
  Future<DataState<String>> editMilestone(
      {required EditMilestoneParamsModel editMilestoneParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createMilestoneMutation),
      variables: {
        // "createMilestoneInput": editMilestoneParamsModel.toJson()
      },
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
      {required String materialIssueId}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_deleteMilestoneMutation),
      variables: {"deleteMilestoneId": materialIssueId},
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
