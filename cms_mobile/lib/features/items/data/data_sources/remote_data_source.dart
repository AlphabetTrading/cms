import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/items/data/models/item.dart';
import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class ItemDataSource {
  Future<DataState<List<ItemModel>>> fetchItems(
      GetItemsInputEntity getItemsInput);
}

class ItemDataSourceImpl extends ItemDataSource {
  late final GraphQLClient _client;
  ItemDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<ItemModel>>> fetchItems(
      GetItemsInputEntity getItemsInput) async {
    String fetchItemsQuery =
        r'''query GetWarehouseProducts($filterWarehouseProductInput: FilterWarehouseProductInput, $paginationInput: PaginationInput) {
  getWarehouseProducts(filterWarehouseProductInput: $filterWarehouseProductInput, paginationInput: $paginationInput) {
    items {
      id
      createdAt
      quantity
      product {
        id
        name
      }
    }
  }
}''';

    print(getItemsInput.toJson());
    return _client
        .query(
      QueryOptions(
          document: gql(fetchItemsQuery),
          variables: getItemsInput.toJson()),
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
          requests.map((e) => ItemModel.fromJson(e)).toList());
    });
  }
}
