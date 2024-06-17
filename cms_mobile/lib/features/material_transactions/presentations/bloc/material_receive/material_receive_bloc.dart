import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/create_material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/get_material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/get_material_receive_details.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialReceiveBloc
    extends Bloc<MaterialReceiveEvent, MaterialReceiveState> {
  final GetMaterialReceivesUseCase _materialReceivesUseCase;
  final CreateMaterialReceiveUseCase _createMaterialReceiveUseCase;
  final GetMaterialReceiveDetailsUseCase _getMaterialReceiveDetailsUseCase;

  MaterialReceiveBloc(
      this._materialReceivesUseCase,
      this._createMaterialReceiveUseCase,
      this._getMaterialReceiveDetailsUseCase)
      : super(const MaterialReceiveInitial()) {
    on<GetMaterialReceives>(onGetMaterialReceives);
    on<CreateMaterialReceiveEvent>(onCreateMaterialReceive);
    // on<GetMaterialReceiveDetailsEvent>(onGetMaterialReceiveDetails);
  }

  void onGetMaterialReceives(
      GetMaterialReceives event, Emitter<MaterialReceiveState> emit) async {
    emit(const MaterialReceivesLoading());

    final dataState = await _materialReceivesUseCase(
        params: MaterialReceiveParams(
      filterMaterialReceiveInput: event.filterMaterialReceiveInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
    ));
    if (dataState is DataSuccess) {
      emit(MaterialReceivesSuccess(materialReceives: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialReceivesFailed(error: dataState.error!));
    }
  }

  void onCreateMaterialReceive(CreateMaterialReceiveEvent event,
      Emitter<MaterialReceiveState> emit) async {
    emit(const CreateMaterialReceiveLoading());

    final dataState = await _createMaterialReceiveUseCase(
        params: event.createMaterialReceiveParamsEntity);

    if (dataState is DataSuccess) {
      emit(const CreateMaterialReceiveSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateMaterialReceiveFailed(error: dataState.error!));
    }
  }
}
