import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/products/domain/repository/product_repository.dart';

class GetAllWarehouseProductsUseCase
    implements UseCase<List<WarehouseProductEntity>, String> {
  final ProductRepository repository;

  GetAllWarehouseProductsUseCase(this.repository);

  @override
  Future<DataState<List<WarehouseProductEntity>>> call({String? params}) {
    return repository.getAllWarehouseProducts(params ?? "");
  }
}
