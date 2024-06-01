import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';

abstract class ProductEvent {
  const ProductEvent();
}

class GetWarehouseProducts extends ProductEvent {
  final GetWarehouseProductsInputEntity? getProductsInputEntity;
  const GetWarehouseProducts({this.getProductsInputEntity});
}

class GetAllWarehouseProducts extends ProductEvent {
  final String projectId;
  const GetAllWarehouseProducts(this.projectId);
}


class GetProduct extends ProductEvent {
  final String id;
  const GetProduct(this.id);
}

class CreateProduct extends ProductEvent {
  final String id;
  const CreateProduct(this.id);
}

class UpdateProduct extends ProductEvent {
  final String id;
  const UpdateProduct(this.id);
}

class DeleteProduct extends ProductEvent {
  final String id;
  const DeleteProduct(this.id);
}
