import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/items/data/models/item.dart';
import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class ItemDataSource {
  Future<DataState<List<WarehouseItemModel>>> fetchItems(
      GetWarehouseItemsInputEntity? getItemsInput);

  Future<DataState<List<WarehouseItemModel>>> fetchAllStockItems(
      String projectId);
}

class ItemDataSourceImpl extends ItemDataSource {
  late final GraphQLClient _client;
  ItemDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<WarehouseItemModel>>> fetchItems(
      GetWarehouseItemsInputEntity? getItemsInput) async {
    String fetchItemsQuery =
        r'''query GetWarehouseProducts($filterWarehouseProductInput: FilterWarehouseProductInput, $paginationInput: PaginationInput) {
  getWarehouseProducts(filterWarehouseProductInput: $filterWarehouseProductInput, paginationInput: $paginationInput) {
    items {
      id
      quantity
      currentPrice
      productVariant {
        id
        variant
        unitOfMeasure
        product {
          id
          name
        }
      }
    }
  }
}''';

    // print(getItemsInput.toJson());
    return _client
        .query(
      QueryOptions(
          document: gql(fetchItemsQuery),
          variables: getItemsInput?.toJson() ?? {}),
    )
        .then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }
      final requests = response.data!['getWarehouseProducts']['items'] as List;
      // print(requests.map((e) => WarehouseItemModel.fromJson(e)).toList());
      return DataSuccess(
          requests.map((e) => WarehouseItemModel.fromJson(e)).toList());
    });
  }

  @override
  Future<DataState<List<WarehouseItemModel>>> fetchAllStockItems(
      String projectId) async {
    String fetchAllStockItemsQuery =
        r'''query GetAllWarehouseProductsStock($projectId: String!) {
  getAllWarehouseProductsStock(projectId: $projectId) {
    currentPrice
    quantity
    productVariant {
      id
      unitOfMeasure
      variant
      description
      product {
        id
        name
        productType
      }
    }
  }
}''';
    final response = await _client
        .query(QueryOptions(document: gql(fetchAllStockItemsQuery), variables: {
      'projectId': '2cf44029-fe54-4e91-a031-f8fd7c65bce5',
    }));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final requests = response.data!['getAllWarehouseProductsStock'] as List;

    return DataSuccess(
        requests.map((e) => WarehouseItemModel.fromJson(e)).toList());
  }
}
