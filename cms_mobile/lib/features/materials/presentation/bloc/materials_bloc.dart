import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/materials/domain/usecases/get_materials.dart';
import 'package:cms_mobile/features/materials/presentation/bloc/materials_event.dart';
import 'package:cms_mobile/features/materials/presentation/bloc/materials_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  final GetMaterialsUseCase _getMaterialsUseCase;
  MaterialBloc(this._getMaterialsUseCase) : super(const MaterialInitial()) {
    on<GetMaterials>(onGetMaterials);
  }

  void onGetMaterials(GetMaterials event, Emitter<MaterialState> emit) async {
    emit(const MaterialLoading());
    final dataState = await _getMaterialsUseCase();
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(MaterialSuccess(materials: dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(MaterialFailed(error: dataState.error!));
    }
  }
}
