import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/products/domain/repository/product_repository.dart';

class GetProductsUseCase implements UseCase<List<WarehouseProductEntity>, GetWarehouseProductsInputEntity?> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<DataState<List<WarehouseProductEntity>>> call({GetWarehouseProductsInputEntity? params}) {
    return repository.getWarehouseProducts(params);
  }
}
