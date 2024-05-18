import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:equatable/equatable.dart';

abstract class ItemState extends Equatable {
  final List<WarehouseItemEntity>? warehouseItems;
  final List<WarehouseItemEntity>? allWarehouseItems;

  final Failure? error;
  const ItemState({this.warehouseItems, this.error, this.allWarehouseItems});

  @override
  List<Object?> get props => [warehouseItems, error];
}

class ItemInitial extends ItemState {
  const ItemInitial();
}

class ItemsLoading extends ItemState {
  const ItemsLoading();
}

class ItemsSuccess extends ItemState {
  const ItemsSuccess({required List<WarehouseItemEntity> warehouseItems})
      : super(warehouseItems: warehouseItems);
}

class ItemsFailed extends ItemState {
  const ItemsFailed({required Failure error}) : super(error: error);
}

class ItemsEmpty extends ItemState {
  const ItemsEmpty();
}

class AllWarehouseItemsLoading extends ItemState {
  const AllWarehouseItemsLoading();
}

class AllWarehouseItemsSuccess extends ItemState {
  const AllWarehouseItemsSuccess(
      {required List<WarehouseItemEntity> allWarehouseItems})
      : super(allWarehouseItems: allWarehouseItems);
}

class AllWarehouseItemsFailed extends ItemState {
  const AllWarehouseItemsFailed({required Failure error}) : super(error: error);
}
