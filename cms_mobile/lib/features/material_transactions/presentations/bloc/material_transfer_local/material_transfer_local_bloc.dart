import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialTransferLocalBloc
    extends Bloc<MaterialTransferLocalEvent, MaterialTransferLocalState> {
  MaterialTransferLocalBloc() : super(const MaterialTransferLocalState()) {
    on<GetMaterialTransferMaterialsLocal>((event, emit) {});

    on<AddMaterialTransferMaterialLocal>((event, emit) {
      final updatedList = List<MaterialTransferEntity>.from(
          state.materialTransferMaterials ?? [])
        ..add(event.materialTransferMaterial);
      emit(MaterialTransferLocalState(materialTransferMaterials: updatedList));
    });

    on<AddMaterialTransferMaterialsLocal>((event, emit) {

      emit(MaterialTransferLocalState(materialTransferMaterials: event.materialTransferMaterials));
    });

    on<DeleteMaterialTransferMaterialLocal>((event, emit) {
      final updatedList = List<MaterialTransferEntity>.from(
          state.materialTransferMaterials ?? [])
        ..removeAt(event.index);
      emit(MaterialTransferLocalState(materialTransferMaterials: updatedList));
    });
    on<EditMaterialTransferMaterialLocal>((event, emit) {
      final updatedList = List<MaterialTransferEntity>.from(
          state.materialTransferMaterials ?? [])
        ..removeAt(event.index)
        ..insert(event.index, event.materialTransferMaterial);
      emit(MaterialTransferLocalState(materialTransferMaterials: updatedList));
    });

    on<ClearMaterialTransferMaterialsLocal>((event, emit) {
      emit(const MaterialTransferLocalState(materialTransferMaterials: []));
    });
  }
}
