import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialRequestDataSource {
  Future<DataState<MaterialRequestModel>> createMaterialRequest(
      {required CreateMaterialRequestParamsModel
          createMaterialRequestParamsModel});
}

class MaterialRequestDataSourceImpl extends MaterialRequestDataSource {
  late final GraphQLClient _client;
// Define the mutation

  static const String _createMaterialRequestMutation = '''

  ''';

  // Override the function in the implementation class
  @override
  Future<DataState<MaterialRequestModel>> createMaterialRequest(
      {required CreateMaterialRequestParamsModel
          createMaterialRequestParamsModel}) async {
    List<Map<String, dynamic>> materialRequestMaterialsMap =
        createMaterialRequestParamsModel.materialRequestMaterials
            .map((materialRequestMaterial) {
      return {
        'requestedQuantity': materialRequestMaterial.requestedQuantity,
        'materialId': materialRequestMaterial.material.id,
        'remark': materialRequestMaterial.remark,
        'unitOfMeasure': materialRequestMaterial.unit,
        'toBePurchasedQuantity': materialRequestMaterial.requestedQuantity -
            materialRequestMaterial.material.quantity,
      };
    }).toList();

    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialRequestMutation),
      variables: {
        "createMaterialRequestInput": {
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
      final MaterialRequestModel materialRequest =
          MaterialRequestModel.fromJson(result.data!['createMaterialRequest']);

      return DataSuccess(materialRequest);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }
}
