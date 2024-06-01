import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/products/data/data_sources/remote_data_source.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/domain/repository/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository{
  final ProductDataSource dataSource;
  ProductRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<List<WarehouseProductModel>>> getWarehouseProducts(GetWarehouseProductsInputEntity? getProductsInput) {
    return dataSource.fetchProducts(getProductsInput);
  }
  
  @override
  Future<DataState<List<WarehouseProductModel>>> getAllWarehouseProducts(String projectId) {
    return dataSource.fetchAllStockProducts(projectId);
  }

}