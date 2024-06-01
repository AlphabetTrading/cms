import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialIssueLocalBloc
    extends Bloc<MaterialIssueLocalEvent, MaterialIssueLocalState> {
  MaterialIssueLocalBloc() : super(const MaterialIssueLocalState()) {
    on<GetMaterialIssueMaterialsLocal>((event, emit) {});

    on<AddMaterialIssueMaterialLocal>((event, emit) {
      final updatedList = List<MaterialIssueMaterialEntity>.from(
          state.materialIssueMaterials ?? [])
        ..add(event.materialIssueMaterial);
      emit(MaterialIssueLocalState(materialIssueMaterials: updatedList));
    });

    on<AddMaterialIssueMaterialsLocal>((event, emit) {

      emit(MaterialIssueLocalState(materialIssueMaterials: event.materialIssueMaterials));
    });

    on<DeleteMaterialIssueMaterialLocal>((event, emit) {
      final updatedList = List<MaterialIssueMaterialEntity>.from(
          state.materialIssueMaterials ?? [])
        ..removeAt(event.index);
      emit(MaterialIssueLocalState(materialIssueMaterials: updatedList));
    });
    on<EditMaterialIssueMaterialLocal>((event, emit) {
      final updatedList = List<MaterialIssueMaterialEntity>.from(
          state.materialIssueMaterials ?? [])
        ..removeAt(event.index)
        ..insert(event.index, event.materialIssueMaterial);
      emit(MaterialIssueLocalState(materialIssueMaterials: updatedList));
    });

    on<ClearMaterialIssueMaterialsLocal>((event, emit) {
      emit(const MaterialIssueLocalState(materialIssueMaterials: []));
    });
  }
}
