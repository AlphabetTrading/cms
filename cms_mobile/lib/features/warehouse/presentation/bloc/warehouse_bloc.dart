import 'package:bloc/bloc.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/warehouse/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/domain/usecases/get_warehouses.dart';
import 'package:equatable/equatable.dart';

part 'warehouse_event.dart';
part 'warehouse_state.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  final GetWarehousesUseCase _getWarehousesUseCase;
  WarehouseBloc(this._getWarehousesUseCase) : super(const WarehouseInitial()) {
    on<GetWarehousesEvent>(onGetWarehouses);
  }
  void onGetWarehouses(
      GetWarehousesEvent event, Emitter<WarehouseState> emit) async {
    emit(const WarehousesLoading());
    final dataState = await _getWarehousesUseCase(
        params: WarehouseParams(
      filterWarehouseStoreInput: event.filterWarehouseStoreInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
    ));
    if (dataState is DataSuccess) {
      emit(WarehousesSuccess(warehouses: dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(WarehousesFailed(error: dataState.error!));
    }
  }
}
