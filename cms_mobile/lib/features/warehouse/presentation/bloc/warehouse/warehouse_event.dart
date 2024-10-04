part of 'warehouse_bloc.dart';

sealed class WarehouseEvent extends Equatable {
  const WarehouseEvent();

  @override
  List<Object> get props => [];
}

class GetWarehousesEvent extends WarehouseEvent {
  final FilterWarehouseStoreInput? filterWarehouseStoreInput;
  final OrderByWarehouseStoreInput? orderBy;
  final PaginationInput? paginationInput;
  const GetWarehousesEvent({
    this.filterWarehouseStoreInput,
    this.orderBy,
    this.paginationInput,
  });
}

class CreateWarehouseEvent extends WarehouseEvent {
  final CreateWarehouseParamsEntity createWarehouseParamsEntity;

  const CreateWarehouseEvent({required this.createWarehouseParamsEntity});
}
