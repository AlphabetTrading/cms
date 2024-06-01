import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialIssueDataSource {
  Future<DataState<String>> createMaterialIssue(
      {required CreateMaterialIssueParamsModel createMaterialIssueParamsModel});
  Future<DataState<MaterialIssueModel>> getMaterialIssueDetails(
      {required String params});
  Future<DataState<String>> editMaterialIssue(
      {required EditMaterialIssueParamsModel editMaterialIssueParamsModel});
  Future<DataState<String>> deleteMaterialIssue({required String materialId});
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

  static const String _deleteMaterialIssueMutation = r'''
  mutation DeleteMaterialIssue($deleteMaterialIssueId: String!) {
  deleteMaterialIssue(id: $deleteMaterialIssueId) {
    id
  }
}''';

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

  @override
  Future<DataState<MaterialIssueModel>> getMaterialIssueDetails(
      {required String params}) {
    String fetchMaterialIssueDetailsQuery = r'''
query GetMaterialIssueById($getMaterialIssueByIdId: String!) {
  getMaterialIssueById(id: $getMaterialIssueByIdId) {
    items {
      createdAt
      id
      productVariant {
        id
        variant
        unitOfMeasure
        product {
          id
          name
        }
      }
      quantity
      remark
      totalCost
      unitCost
      subStructureDescription
      superStructureDescription
      updatedAt
      useType
      materialIssueVoucherId
    }
    requisitionNumber
    serialNumber
    status
    id
    
    approvedById
    createdAt
    approvedBy {

              createdAt
              email
              fullName
              id
              phoneNumber
              role
              updatedAt
    }
    preparedBy {
                 createdAt
              email
              fullName
              id
              phoneNumber
              role
              updatedAt
    }
        warehouseStore {
      id
      location
      name
    }

  }
}
    ''';

    return _client
        .query(QueryOptions(
      document: gql(fetchMaterialIssueDetailsQuery),
      variables: {"getMaterialIssueByIdId": params},
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
          MaterialIssueModel.fromJson(response.data!['getMaterialIssueById']);
      print(response.data!['getMaterialIssueById']);

      return DataSuccess(materialIssue);
    });
  }

  @override
  Future<DataState<String>> editMaterialIssue(
      {required EditMaterialIssueParamsModel
          editMaterialIssueParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialIssueMutation),
      variables: {
        "createMaterialIssueInput": editMaterialIssueParamsModel.toJson()
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['updateMaterialIssue']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<String>> deleteMaterialIssue(
      {required String materialId}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_deleteMaterialIssueMutation),
      variables: {"deleteMaterialIssueId": materialId},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['deleteMaterialIssue']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }
}
