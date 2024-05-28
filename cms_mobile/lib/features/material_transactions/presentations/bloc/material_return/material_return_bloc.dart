import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/create_material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialReturnBloc
    extends Bloc<MaterialReturnEvent, MaterialReturnState> {
  // final GetMaterialReturnUseCase _materialReturnUseCase;
  final CreateMaterialReturnUseCase _createMaterialReturnUseCase;

  MaterialReturnBloc(this._createMaterialReturnUseCase)
      : super(const MaterialReturnInitial()) {
    // on<GetMaterialReturns>(onGetMaterialReturns);
    on<CreateMaterialReturnEvent>(onCreateMaterialReturn);
  }

  // void onGetMaterialReturns(
  //     GetMaterialReturns event, Emitter<MaterialReturnState> emit) async {
  //   final dataState = await _materialReturnUseCase();

  //   if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
  //     // emit(MaterialReturnSuccess(materialReturns: dataState.data!));
  //   }

  //   if (dataState is DataFailed) {
  //     emit(MaterialReturnFailed(error: dataState.error!));
  //   }
  // }
void onCreateMaterialReturn(CreateMaterialReturnEvent event, Emitter<MaterialReturnState> emit) async {
    
    emit(CreateMaterialReturnLoading());
    final dataState = await _createMaterialReturnUseCase(
      params: event.createMaterialReturnParamsEntity
    );

    if (dataState is DataSuccess) {
      emit(CreateMaterialReturnSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateMaterialReturnFailed(error: dataState.error!));
    }

  }


}
