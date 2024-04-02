import 'package:cms_mobile/features/material_transactions/domain/entities/material_request_material.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialRequestLocalBloc
    extends Bloc<MaterialRequestLocalEvent, MaterialRequestLocalState> {
  MaterialRequestLocalBloc() : super(const MaterialRequestLocalState()) {
    on<GetMaterialRequestMaterialsLocal>((event, emit) {});

    on<AddMaterialRequestMaterialLocal>((event, emit) {
      final updatedList = List<MaterialRequestMaterialEntity>.from(
          state.materialRequestMaterials ?? [])
        ..add(event.materialRequestMaterial);
      emit(MaterialRequestLocalState(materialRequestMaterials: updatedList));
    });

    on<DeleteMaterialRequestMaterialLocal>((event, emit) {
      final updatedList = List<MaterialRequestMaterialEntity>.from(
          state.materialRequestMaterials ?? [])
        ..removeAt(event.index);
      emit(MaterialRequestLocalState(materialRequestMaterials: updatedList));
    });
    on<EditMaterialRequestMaterialLocal>((event, emit) {
      final updatedList = List<MaterialRequestMaterialEntity>.from(
          state.materialRequestMaterials ?? [])
        ..removeAt(event.index)
        ..insert(event.index, event.materialRequestMaterial);
      emit(MaterialRequestLocalState(materialRequestMaterials: updatedList));
    });
  }
}
