import 'package:cms_mobile/features/material_requests/data/models/material_request.dart';
import 'package:cms_mobile/features/material_requests/domain/entities/material_request.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialReceivingDataSource {
  Future<List<MaterialRequestModel>> fetchMaterialRequests();
}

class DataState<T> {
  final T? data;
  final String? error;

  DataState({this.data, this.error});
}

class MaterialReceivingDataSourceImpl extends MaterialReceivingDataSource {
  late final GraphQLClient _client;

  MaterialReceivingDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<List<MaterialRequestModel>> fetchMaterialRequests() async {
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
      throw response.exception!;
    }

    final requests = response.data!['requests'] as List;

    return requests
        .map((request) => MaterialRequestModel.fromJson(request))
        .toList();
  }
}
