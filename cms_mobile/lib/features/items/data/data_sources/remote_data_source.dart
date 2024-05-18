import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/items/data/models/item.dart';
import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class ItemDataSource {
  Future<DataState<List<WarehouseItemModel>>> fetchItems(
      GetItemsInputEntity? getItemsInput);

  Future<DataState<List<WarehouseItemModel>>> fetchAllStockItems();
}

class ItemDataSourceImpl extends ItemDataSource {
  late final GraphQLClient _client;
  ItemDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<WarehouseItemModel>>> fetchItems(
      GetItemsInputEntity? getItemsInput) async {
    String fetchItemsQuery =
        r'''query GetWarehouseProducts($filterWarehouseProductInput: FilterWarehouseProductInput, $paginationInput: PaginationInput) {
  getWarehouseProducts(filterWarehouseProductInput: $filterWarehouseProductInput, paginationInput: $paginationInput) {
    items {
      productVariant {
        id
        variant
        product {
          id
          name
        }
      }
      id
      quantity
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

      return DataSuccess(
          requests.map((e) => WarehouseItemModel.fromJson(e)).toList());
    });
  }

  @override
  Future<DataState<List<WarehouseItemModel>>> fetchAllStockItems() async {
    String fetchAllStockItemsQuery = r'''query GetAllWarehouseProductsStock {
  getAllWarehouseProductsStock {
    quantity
    productVariant {
      unitOfMeasure
      variant
      id
      product {
        id
        name
      }
    }
  }
}''';

    final response = await _client.query(QueryOptions(
      document: gql(fetchAllStockItemsQuery),
    ));

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
