import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/warehouse/data/models/warehouse.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class WarehouseDataSource {
  Future<DataState<List<WarehouseModel>>> fetchWarehouses({
    FilterWarehouseStoreInput? filterWarehouseStoreInput,
    OrderByWarehouseStoreInput? orderBy,
    PaginationInput? paginationInput,
  });
}

class WarehouseDataSourceImpl extends WarehouseDataSource {
  late final GraphQLClient _client;

  WarehouseDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<WarehouseModel>>> fetchWarehouses(
      {FilterWarehouseStoreInput? filterWarehouseStoreInput,
      OrderByWarehouseStoreInput? orderBy,
      PaginationInput? paginationInput}) async {
    String fetchWarehousesQuery;

    fetchWarehousesQuery = r'''
      query GetWarehouseStores($orderBy: OrderByWarehouseStoreInput, $filterWarehouseStoreInput: FilterWarehouseStoreInput, $paginationInput: PaginationInput) {
        getWarehouseStores(orderBy: $orderBy, filterWarehouseStoreInput: $filterWarehouseStoreInput, paginationInput: $paginationInput) {
          items {
            createdAt
            id
            location
            name
            updatedAt
          }
          meta {
            count
            limit
            page
          }
        }
      }
    ''';

    dynamic filterInput = filterWarehouseStoreInput != null
        ? filterWarehouseStoreInput.toJson()
        : {};

    final response = await _client.query(QueryOptions(
      document: gql(fetchWarehousesQuery),
      variables: {
        "filterWarehouseStoreInput": filterInput,
        "orderBy": orderBy ?? {},
        "paginationInput": paginationInput ?? {}
      },
      // fetchPolicy: FetchPolicy.noCache,
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

class FilterWarehouseStoreInput {
  final StringFilter? createdAt;
  final StringFilter? company;
  final String? companyId;
  final StringFilter? location;
  final StringFilter? name;
  final String? id;

  FilterWarehouseStoreInput(
      {this.createdAt,
      this.company,
      this.companyId,
      this.location,
      this.name,
      this.id});

  Map<String, dynamic> toJson() {
    // include the property if it is only not null
    return {
      if (company != null)
        'company': {
          'name': company!.toJson(),
        },
      if (companyId != null) 'companyId': companyId,
      if (createdAt != null) 'createdAt': createdAt,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (id != null) 'id': id,
    };
  }
}

class OrderByWarehouseStoreInput {
  final String? createdAt;
  final String? location;
  final String? name;

  OrderByWarehouseStoreInput({this.createdAt, this.location, this.name});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
      if (name != null) "name": name,
      if (location != null) "location": location,
    };
  }
}
