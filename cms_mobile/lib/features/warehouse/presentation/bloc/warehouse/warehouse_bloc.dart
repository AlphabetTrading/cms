import 'package:bloc/bloc.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/warehouse/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/domain/usecases/create_warehouse.dart';
import 'package:cms_mobile/features/warehouse/domain/usecases/get_warehouses.dart';
import 'package:equatable/equatable.dart';

part 'warehouse_event.dart';
part 'warehouse_state.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  final GetWarehousesUseCase _getWarehousesUseCase;
  final CreateWarehouseUseCase _createWarehouseUseCase;
  WarehouseBloc(this._getWarehousesUseCase, this._createWarehouseUseCase)
      : super(const WarehouseInitial()) {
    on<GetWarehousesEvent>(onGetWarehouses);
    on<CreateWarehouseEvent>(onCreateWarehouse);
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

  void onCreateWarehouse(
      CreateWarehouseEvent event, Emitter<WarehouseState> emit) async {
    emit(const CreateWarehouseLoading());

    final dataState = await _createWarehouseUseCase(
        params: event.createWarehouseParamsEntity);

    if (dataState is DataSuccess) {
      emit(const CreateWarehouseSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateWarehouseFailed(error: dataState.error!));
    }
  }
}
