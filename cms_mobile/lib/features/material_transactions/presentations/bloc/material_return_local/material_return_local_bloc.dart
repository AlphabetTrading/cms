import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialReturnLocalBloc
    extends Bloc<MaterialReturnLocalEvent, MaterialReturnLocalState> {
  MaterialReturnLocalBloc() : super(const MaterialReturnLocalState()) {
    on<GetMaterialReturnMaterialsLocal>((event, emit) {});

    on<AddMaterialReturnMaterialLocal>((event, emit) {
      final updatedList = List<MaterialReturnMaterialEntity>.from(
          state.materialReturnMaterials ?? [])
        ..add(event.materialReturnMaterial);
      emit(MaterialReturnLocalState(materialReturnMaterials: updatedList));
    });

    on<DeleteMaterialReturnMaterialLocal>((event, emit) {
      final updatedList = List<MaterialReturnMaterialEntity>.from(
          state.materialReturnMaterials ?? [])
        ..removeAt(event.index);
      emit(MaterialReturnLocalState(materialReturnMaterials: updatedList));
    });
    on<EditMaterialReturnMaterialLocal>((event, emit) {
      final updatedList = List<MaterialReturnMaterialEntity>.from(
          state.materialReturnMaterials ?? [])
        ..removeAt(event.index)
        ..insert(event.index, event.materialReturnMaterial);
      emit(MaterialReturnLocalState(materialReturnMaterials: updatedList));
    });

    on<ClearMaterialReturnMaterialsLocal>((event, emit) {
      emit(const MaterialReturnLocalState(materialReturnMaterials:[]));
    });
  }
}
