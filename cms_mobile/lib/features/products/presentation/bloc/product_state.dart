import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  final List<WarehouseProductEntity>? warehouseProducts;
  final List<WarehouseProductEntity>? allWarehouseProducts;

  final Failure? error;
  const ProductState({this.warehouseProducts, this.error, this.allWarehouseProducts});

  @override
  List<Object?> get props => [warehouseProducts, error];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class WarehouseProductsLoading extends ProductState {
  const WarehouseProductsLoading();
}

class WarehouseProductsSuccess extends ProductState {
  const WarehouseProductsSuccess({required List<WarehouseProductEntity> warehouseProducts})
      : super(warehouseProducts: warehouseProducts);
}

class WarehouseProductsFailed extends ProductState {
  const WarehouseProductsFailed({required Failure error}) : super(error: error);
}

class WarehouseProductsEmpty extends ProductState {
  const WarehouseProductsEmpty();
}

class AllWarehouseProductsLoading extends ProductState {
  const AllWarehouseProductsLoading();
}

class AllWarehouseProductsSuccess extends ProductState {
  const AllWarehouseProductsSuccess(
      {required List<WarehouseProductEntity> allWarehouseProducts})
      : super(allWarehouseProducts: allWarehouseProducts);
}

class AllWarehouseProductsFailed extends ProductState {
  const AllWarehouseProductsFailed({required Failure error}) : super(error: error);
}
