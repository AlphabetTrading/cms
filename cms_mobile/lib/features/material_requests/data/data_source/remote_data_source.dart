import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_requests/data/models/material_request.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialReceivingDataSource {
  Future<DataState<List<MaterialRequestModel>>> fetchMaterialRequests();
}

class MaterialReceivingDataSourceImpl extends MaterialReceivingDataSource {
  late final GraphQLClient _client;

  MaterialReceivingDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<MaterialRequestModel>>> fetchMaterialRequests() async {
    String fetchMaterialRequestsQuery;

    fetchMaterialRequestsQuery = r'''
     query GetMaterialRequests {
        materialRequests_materialRequests {
          id
        }
      }
    ''';

    final response = await _client.query(QueryOptions(
      document: gql(fetchMaterialRequestsQuery),
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final requests = response.data!['requests'] as List;

    return DataSuccess(
        requests.map((e) => MaterialRequestModel.fromJson(e)).toList());
  }
}
