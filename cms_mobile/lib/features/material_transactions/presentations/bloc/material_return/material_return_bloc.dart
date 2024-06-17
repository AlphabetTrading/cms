import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_return/create_material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_return/get_material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialReturnBloc
    extends Bloc<MaterialReturnEvent, MaterialReturnState> {
  final GetMaterialReturnUseCase _materialReturnUseCase;
  final CreateMaterialReturnUseCase _createMaterialReturnUseCase;

  MaterialReturnBloc(
      this._createMaterialReturnUseCase, this._materialReturnUseCase)
      : super(const MaterialReturnInitial()) {
    on<GetMaterialReturns>(onGetMaterialReturns);
    on<CreateMaterialReturnEvent>(onCreateMaterialReturn);
  }

  void onGetMaterialReturns(
      GetMaterialReturns event, Emitter<MaterialReturnState> emit) async {
    emit(const MaterialReturnLoading());

    final dataState = await _materialReturnUseCase();
    debugPrint('dataState: $dataState');
    if (dataState is DataSuccess) {
      emit(MaterialReturnSuccess(materialReturns: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialReturnFailed(error: dataState.error!));
    }
  }

  void onCreateMaterialReturn(CreateMaterialReturnEvent event,
      Emitter<MaterialReturnState> emit) async {
    emit(const CreateMaterialReturnLoading());
    final dataState = await _createMaterialReturnUseCase(
        params: event.createMaterialReturnParamsEntity);

    if (dataState is DataSuccess) {
      emit(const CreateMaterialReturnSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateMaterialReturnFailed(error: dataState.error!));
    }
  }
}
