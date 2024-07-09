import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma_local/material_proforma_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma_local/material_proforma_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialProformaLocalBloc
    extends Bloc<MaterialProformaLocalEvent, MaterialProformaLocalState> {
  MaterialProformaLocalBloc() : super(const MaterialProformaLocalState()) {
    on<GetMaterialProformaMaterialsLocal>((event, emit) {});

    on<AddMaterialProformaMaterialLocal>((event, emit) {
      final updatedList = List<MaterialProformaMaterialEntity>.from(
          state.materialProformaMaterials ?? [])
        ..add(event.materialProformaMaterial);
      emit(MaterialProformaLocalState(materialProformaMaterials: updatedList));
    });

    on<AddMaterialProformaMaterialsLocal>((event, emit) {

      emit(MaterialProformaLocalState(materialProformaMaterials: event.materialProformaMaterials));
    });

    on<DeleteMaterialProformaMaterialLocal>((event, emit) {
      final updatedList = List<MaterialProformaMaterialEntity>.from(
          state.materialProformaMaterials ?? [])
        ..removeAt(event.index);
      emit(MaterialProformaLocalState(materialProformaMaterials: updatedList));
    });
    on<EditMaterialProformaMaterialLocal>((event, emit) {
      final updatedList = List<MaterialProformaMaterialEntity>.from(
          state.materialProformaMaterials ?? [])
        ..removeAt(event.index)
        ..insert(event.index, event.materialProformaMaterial);
      emit(MaterialProformaLocalState(materialProformaMaterials: updatedList));
    });

    on<ClearMaterialProformaMaterialsLocal>((event, emit) {
      emit(const MaterialProformaLocalState(materialProformaMaterials: []));
    });
  }
}
