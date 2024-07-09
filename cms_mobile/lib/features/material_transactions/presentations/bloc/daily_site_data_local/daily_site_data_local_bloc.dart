import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailySiteDataLocalBloc
    extends Bloc<DailySiteDataLocalEvent, DailySiteDataLocalState> {
  DailySiteDataLocalBloc() : super(const DailySiteDataLocalState()) {
    on<GetDailySiteDataMaterialsLocal>((event, emit) {});

    on<AddDailySiteDataMaterialLocal>((event, emit) {
      final updatedList = List<DailySiteDataEnitity>.from(
          state.dailySiteDataMaterials ?? [])
        ..add(event.dailySiteDataMaterial);
      emit(DailySiteDataLocalState(dailySiteDataMaterials: updatedList));
    });

    on<AddDailySiteDataMaterialsLocal>((event, emit) {
      emit(DailySiteDataLocalState(
          dailySiteDataMaterials: event.dailySiteDataMaterials));
    });

    on<DeleteDailySiteDataMaterialLocal>((event, emit) {
      final updatedList = List<DailySiteDataEnitity>.from(
          state.dailySiteDataMaterials ?? [])
        ..removeAt(event.index);
      emit(DailySiteDataLocalState(dailySiteDataMaterials: updatedList));
    });
    on<EditDailySiteDataMaterialLocal>((event, emit) {
      final updatedList = List<DailySiteDataEnitity>.from(
          state.dailySiteDataMaterials ?? [])
        ..removeAt(event.index)
        ..insert(event.index, event.dailySiteDataMaterial);
      emit(DailySiteDataLocalState(dailySiteDataMaterials: updatedList));
    });

    on<ClearDailySiteDataMaterialsLocal>((event, emit) {
      emit(const DailySiteDataLocalState(dailySiteDataMaterials: []));
    });
  }
}
