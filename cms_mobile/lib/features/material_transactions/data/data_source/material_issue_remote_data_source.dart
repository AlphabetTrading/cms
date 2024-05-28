import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialIssueDataSource {
  Future<DataState<String>> createMaterialIssue(
      {required CreateMaterialIssueParamsModel createMaterialIssueParamsModel});
}

class MaterialIssueDataSourceImpl extends MaterialIssueDataSource {
  late final GraphQLClient _client;
// Define the mutation
  MaterialIssueDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createMaterialIssueMutation = r'''
mutation CreateMaterialIssue($createMaterialIssueInput: CreateMaterialIssueInput!) {
  createMaterialIssue(createMaterialIssueInput: $createMaterialIssueInput) {
    id
  }
}

  ''';

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createMaterialIssue(
      {required CreateMaterialIssueParamsModel
          createMaterialIssueParamsModel}) async {

    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialIssueMutation),
      variables: {
        "createMaterialIssueInput": createMaterialIssueParamsModel.toJson()
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);
      print(result);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['createMaterialIssue']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }
}
