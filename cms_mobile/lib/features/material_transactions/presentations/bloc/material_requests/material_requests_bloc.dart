import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/create_material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_requests.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialRequestBloc
    extends Bloc<MaterialRequestEvent, MaterialRequestState> {
  final GetMaterialRequestUseCase _materialRequestUseCase;
  final CreateMaterialRequestUseCase _createMaterialRequestUseCase;

  MaterialRequestBloc(this._materialRequestUseCase,this._createMaterialRequestUseCase)
      : super(const MaterialRequestInitial()) {
    on<GetMaterialRequestEvent>(onGetMaterialRequests);
        on<CreateMaterialRequestEvent>(onCreateMaterialRequest);
  }

  void onGetMaterialRequests(
      GetMaterialRequestEvent event, Emitter<MaterialRequestState> emit) async {
    final dataState = await _materialRequestUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(MaterialRequestSuccess(materialRequests: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialRequestFailed(error: dataState.error!));
    }
  }

  void onCreateMaterialRequest(CreateMaterialRequestEvent event, Emitter<MaterialRequestState> emit) async {
    
    emit(CreateMaterialRequestLoading());
    final dataState = await _createMaterialRequestUseCase(
      params: event.createMaterialRequestParamsEntity
    );

    if (dataState is DataSuccess) {
      emit(CreateMaterialRequestSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateMaterialRequestFailed(error: dataState.error!));
    }

  }

}
