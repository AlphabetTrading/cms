import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_local/warehouse_local_event.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_local/warehouse_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseLocalBloc
    extends Bloc<WarehouseLocalEvent, WarehouseLocalState> {
  WarehouseLocalBloc() : super(const WarehouseLocalState()) {
    on<GetWarehouseLocal>((event, emit) {});

    on<AddWarehouseLocal>((event, emit) {
      final updatedList = List<WarehouseEntity>.from(state.warehouses ?? [])
        ..add(event.warehouse);
      emit(WarehouseLocalState(warehouses: updatedList));
    });

    on<AddWarehousesLocal>((event, emit) {
      emit(WarehouseLocalState(warehouses: event.warehouses));
    });

    on<DeleteWarehouseLocal>((event, emit) {
      final updatedList = List<WarehouseEntity>.from(state.warehouses ?? [])
        ..removeAt(event.index);
      emit(WarehouseLocalState(warehouses: updatedList));
    });
    on<EditWarehouseLocal>((event, emit) {
      final updatedList = List<WarehouseEntity>.from(state.warehouses ?? [])
        ..removeAt(event.index)
        ..insert(event.index, event.warehouse);
      emit(WarehouseLocalState(warehouses: updatedList));
    });

    on<ClearWarehouseLocal>((event, emit) {
      emit(const WarehouseLocalState(warehouses: []));
    });
  }
}
