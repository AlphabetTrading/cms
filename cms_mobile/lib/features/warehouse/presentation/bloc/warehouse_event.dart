part of 'warehouse_bloc.dart';

sealed class WarehouseEvent extends Equatable {
  const WarehouseEvent();

  @override
  List<Object> get props => [];
}


class GetWarehousesEvent extends WarehouseEvent {
  const GetWarehousesEvent();
}