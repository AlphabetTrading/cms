import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/warehouse/data/models/warehouse.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class WarehouseDataSource {
  Future<DataState<List<WarehouseModel>>> fetchWarehouses();
}

class WarehouseDataSourceImpl extends WarehouseDataSource {
  late final GraphQLClient _client;

  WarehouseDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<WarehouseModel>>> fetchWarehouses() async {
    
    String fetchWarehousesQuery;

    fetchWarehousesQuery = r'''
        query GetWarehouseStore {
          getWarehouseStores {
            items {
              location
              name
              id
            }
          }
        }
    ''';

    final response = await _client.query(QueryOptions(
      document: gql(fetchWarehousesQuery),
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final requests = response.data!['getWarehouseStores']['items'] as List;

    return DataSuccess(
        requests.map((e) => WarehouseModel.fromJson(e)).toList());
  }
}
