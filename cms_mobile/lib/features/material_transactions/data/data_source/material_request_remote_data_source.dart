import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialRequestDataSource {
 
 Future<DataState<MaterialRequestModel>> createMaterialRequest({
    required String name,
    required int quantity,
    required String description,
  });
}

class MaterialRequestDataSourceImpl extends MaterialRequestDataSource {
  late final GraphQLClient _client;

  static const String _createMaterialRequestMutation = '''
    mutation CreateMaterialRequest(\$name: String!, \$quantity: Int!, \$description: String!) {
      createMaterialRequest(input: {name: \$name, quantity: \$quantity, description: \$description}) {
        id
        name
        quantity
        status
      }
    }
  ''';

  // Override the function in the implementation class
  @override
  Future<DataState<MaterialRequestModel>> createMaterialRequest({
    required String name,
    required int quantity,
    required String description,
  }) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialRequestMutation),
      variables: {
        'name': name,
        'quantity': quantity,
        'description': description,
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final MaterialRequestModel materialRequest = MaterialRequestModel.fromJson(result.data!['createMaterialRequest']);

      return DataSuccess(materialRequest);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }
}

  

