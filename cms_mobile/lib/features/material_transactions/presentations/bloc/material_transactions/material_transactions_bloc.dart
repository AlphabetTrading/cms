import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/get_material_requests.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialRequestBloc
    extends Bloc<MaterialRequestEvent, MaterialRequestState> {
  final GetMaterialRequestsUseCase _materialRequestUseCase;

  MaterialRequestBloc(this._materialRequestUseCase)
      : super(const MaterialRequestInitial()) {
    on<GetMaterialRequestEvent>(onGetMaterialRequests);
  }

  void onGetMaterialRequests(
      GetMaterialRequestEvent event, Emitter<MaterialRequestState> emit) async {
    final dataState = await _materialRequestUseCase();

    if (dataState is DataSuccess) {
      emit(MaterialRequestSuccess(materialRequests: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialRequestFailed(error: dataState.error!));
    }
  }
}
