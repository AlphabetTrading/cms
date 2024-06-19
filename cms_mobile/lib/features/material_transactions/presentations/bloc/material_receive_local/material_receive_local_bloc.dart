import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialReceiveLocalBloc
    extends Bloc<MaterialReceiveLocalEvent, MaterialReceiveLocalState> {
  MaterialReceiveLocalBloc() : super(const MaterialReceiveLocalState()) {
    on<GetMaterialReceiveMaterialsLocal>((event, emit) {});

    on<AddMaterialReceiveMaterialLocal>((event, emit) {
      final updatedList = List<MaterialReceiveMaterialEntity>.from(
          state.materialReceiveMaterials ?? [])
        ..add(event.materialReceiveMaterial);
      emit(MaterialReceiveLocalState(materialReceiveMaterials: updatedList));
    });

    on<AddMaterialReceiveMaterialsLocal>((event, emit) {
      emit(MaterialReceiveLocalState(
          materialReceiveMaterials: event.materialReceiveMaterials));
    });

    on<DeleteMaterialReceiveMaterialLocal>((event, emit) {
      final updatedList = List<MaterialReceiveMaterialEntity>.from(
          state.materialReceiveMaterials ?? [])
        ..removeAt(event.index);
      emit(MaterialReceiveLocalState(materialReceiveMaterials: updatedList));
    });
    on<EditMaterialReceiveMaterialLocal>((event, emit) {
      final updatedList = List<MaterialReceiveMaterialEntity>.from(
          state.materialReceiveMaterials ?? [])
        ..removeAt(event.index)
        ..insert(event.index, event.materialReceiveMaterial);
      emit(MaterialReceiveLocalState(materialReceiveMaterials: updatedList));
    });

    on<ClearMaterialReceiveMaterialsLocal>((event, emit) {
      emit(const MaterialReceiveLocalState(materialReceiveMaterials: []));
    });
  }
}
