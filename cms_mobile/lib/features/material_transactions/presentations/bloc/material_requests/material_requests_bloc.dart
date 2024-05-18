import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_requests.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialRequestBloc
    extends Bloc<MaterialRequestEvent, MaterialRequestState> {
  final GetMaterialRequestUseCase _materialRequestUseCase;

  MaterialRequestBloc(this._materialRequestUseCase)
      : super(const MaterialRequestInitial()) {
    on<GetMaterialRequest>(onGetMaterialRequests);
  }

  void onGetMaterialRequests(
      GetMaterialRequest event, Emitter<MaterialRequestState> emit) async {
    final dataState = await _materialRequestUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(MaterialRequestSuccess(materialRequests: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialRequestFailed(error: dataState.error!));
    }
  }

}
