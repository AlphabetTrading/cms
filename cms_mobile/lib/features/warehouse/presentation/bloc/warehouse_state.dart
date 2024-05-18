part of 'warehouse_bloc.dart';

sealed class WarehouseState extends Equatable {
  final List<WarehouseEntity>? warehouses;
  final Failure? error;
  const WarehouseState({this.warehouses,this.error});

  @override
  List<Object?> get props => [warehouses,error];
}

final class WarehouseInitial extends WarehouseState {
  const WarehouseInitial();
}

class WarehousesLoading extends WarehouseState {
  const WarehousesLoading();
}


class WarehousesSuccess extends WarehouseState {
  const WarehousesSuccess(
      {required List<WarehouseEntity> warehouses})
      : super(warehouses:warehouses);
}

class WarehousesFailed extends WarehouseState {
  const WarehousesFailed({required Failure error}) : super(error: error);
}

