import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialRequestDataSource {
  Future<DataState<String>> createMaterialRequest(
      {required CreateMaterialRequestParamsModel
          createMaterialRequestParamsModel});
}

class MaterialRequestDataSourceImpl extends MaterialRequestDataSource {
  late final GraphQLClient _client;
// Define the mutation
  MaterialRequestDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createMaterialRequestMutation = r'''
mutation CreateMaterialRequest($createMaterialRequestInput: CreateMaterialRequestInput!) {
  createMaterialRequest(createMaterialRequestInput: $createMaterialRequestInput) {
    id
  }
}

  ''';

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createMaterialRequest(
      {required CreateMaterialRequestParamsModel
          createMaterialRequestParamsModel}) async {
    List<Map<String, dynamic>> materialRequestMaterialsMap =
        createMaterialRequestParamsModel.materialRequestMaterials
            .map((materialRequestMaterial) {
      return {
        "quantity": materialRequestMaterial.requestedQuantity,
        "productVariantId": materialRequestMaterial.material!.itemVariant.id,
        "remark": materialRequestMaterial.remark,
      };
    }).toList();

    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialRequestMutation),
      variables: {
        "createMaterialRequestInput": {
          "requestedById": createMaterialRequestParamsModel.requestedById,
          "projectId": createMaterialRequestParamsModel.projectId,
          "items": materialRequestMaterialsMap
        }
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['createMaterialRequest']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }
}
