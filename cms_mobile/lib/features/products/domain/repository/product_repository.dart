import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';


abstract class ProductRepository{
  Future<DataState<List<WarehouseProductModel>>> getWarehouseProducts(GetWarehouseProductsInputEntity? getProductsInput);
  Future<DataState<List<WarehouseProductModel>>> getAllWarehouseProducts(String projectId);

}