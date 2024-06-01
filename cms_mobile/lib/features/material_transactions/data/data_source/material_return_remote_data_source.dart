import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialReturnDataSource {
  Future<DataState<String>> createMaterialReturn(
      {required CreateMaterialReturnParamsModel createMaterialReturnParamsModel});
}

class MaterialReturnDataSourceImpl extends MaterialReturnDataSource {
  late final GraphQLClient _client;
// Define the mutation
  MaterialReturnDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createMaterialReturnMutation = r'''
mutation CreateMaterialReturn($createMaterialReturnInput: CreateMaterialReturnInput!) {
  createMaterialReturn(createMaterialReturnInput: $createMaterialReturnInput) {
    id
  }
}

  ''';

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createMaterialReturn(
      {required CreateMaterialReturnParamsModel
          createMaterialReturnParamsModel}) async {
    List<Map<String, dynamic>> materialReturnMaterialsMap =
        createMaterialReturnParamsModel.materialReturnMaterials
            .map((materialReturnMaterial) {
      return {
        "productVariantId": materialReturnMaterial.material!.productVariant.id,
        "quantity": materialReturnMaterial.quantity,
        "remark": materialReturnMaterial.remark,
        "unitCost": materialReturnMaterial.unitCost,
        "totalCost": materialReturnMaterial.unitCost *
            materialReturnMaterial.quantity,
      };
    }).toList();

    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialReturnMutation),
      variables: {
        "createMaterialReturnInput": {
          "projectId": "2cf44029-fe54-4e91-a031-f8fd7c65bce5",
          "preparedById": "2bdcd10f-b487-4c1a-84a0-090fef032ba1",
          "items": materialReturnMaterialsMap
        }
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
      final String id = result.data!['createMaterialReturn']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }
}
