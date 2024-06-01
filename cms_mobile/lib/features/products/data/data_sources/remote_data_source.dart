import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class ProductDataSource {
  Future<DataState<List<WarehouseProductModel>>> fetchProducts(
      GetWarehouseProductsInputEntity? getProductsInput);

  Future<DataState<List<WarehouseProductModel>>> fetchAllStockProducts(
      String projectId);
}

class ProductDataSourceImpl extends ProductDataSource {
  late final GraphQLClient _client;
  ProductDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<WarehouseProductModel>>> fetchProducts(
      GetWarehouseProductsInputEntity? getProductsInput) async {
    String fetchProductsQuery =
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

    // print(getProductsInput.toJson());
    return _client
        .query(
      QueryOptions(
          document: gql(fetchProductsQuery),
          variables: getProductsInput?.toJson() ?? {}),
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
      // print(requests.map((e) => WarehouseProductModel.fromJson(e)).toList());
      return DataSuccess(
          requests.map((e) => WarehouseProductModel.fromJson(e)).toList());
    });
  }

  @override
  Future<DataState<List<WarehouseProductModel>>> fetchAllStockProducts(
      String projectId) async {
    String fetchAllStockProductsQuery =
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
        .query(QueryOptions(document: gql(fetchAllStockProductsQuery), variables: {
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
        requests.map((e) => WarehouseProductModel.fromJson(e)).toList());
  }
}
