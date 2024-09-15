import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/approve_material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/create_material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/get_material_requests.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialRequestBloc
    extends Bloc<MaterialRequestEvent, MaterialRequestState> {
  final GetMaterialRequestsUseCase _materialRequestUseCase;
  final CreateMaterialRequestUseCase _createMaterialRequestUseCase;
  final ApproveMaterialRequestUseCase _approveMaterialRequestUseCase;

  MaterialRequestBloc(this._materialRequestUseCase,
      this._createMaterialRequestUseCase, this._approveMaterialRequestUseCase)
      : super(const MaterialRequestInitial()) {
    on<GetMaterialRequestEvent>(onGetMaterialRequests);
    on<ApproveMaterialRequestEvent>(onApproveMaterialRequest);
    on<CreateMaterialRequestEvent>(onCreateMaterialRequest);
  }

  void onGetMaterialRequests(
      GetMaterialRequestEvent event, Emitter<MaterialRequestState> emit) async {
    emit(const MaterialRequestLoading());
    debugPrint(
        "Get MaterialRequests called ${event.filterMaterialRequestInput}");
    final dataState = await _materialRequestUseCase(
        params: MaterialRequestParams(
      filterMaterialRequestInput: event.filterMaterialRequestInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
    ));

    if (dataState is DataSuccess) {
      debugPrint(
          'DataState MaterialRequests Size : ${dataState.data!.items.length}');

      emit(MaterialRequestSuccess(materialRequests: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialRequestFailed(error: dataState.error!));
    }
  }

  void onCreateMaterialRequest(CreateMaterialRequestEvent event,
      Emitter<MaterialRequestState> emit) async {
    emit(const CreateMaterialRequestLoading());
    final dataState = await _createMaterialRequestUseCase(
        params: event.createMaterialRequestParamsEntity);

    if (dataState is DataSuccess) {
      emit(const CreateMaterialRequestSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateMaterialRequestFailed(error: dataState.error!));
    }
  }

  void onApproveMaterialRequest(ApproveMaterialRequestEvent event,
      Emitter<MaterialRequestState> emit) async {
    emit(const ApproveMaterialRequestLoading());

    final dataState = await _approveMaterialRequestUseCase(
        params: ApproveMaterialRequestParamsModel(
            decision: event.decision,
            materialRequestId: event.materialRequestId));

    debugPrint('Response: $dataState');

    if (dataState is DataSuccess) {
      emit(const ApproveMaterialRequestSuccess());
    }

    if (dataState is DataFailed) {
      emit(ApproveMaterialRequestFailed(error: dataState.error!));
    }
  }
}
