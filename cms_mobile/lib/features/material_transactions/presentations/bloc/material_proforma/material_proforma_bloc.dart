import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/create_material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/get_material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_state.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const throttleDuration = Duration(seconds: 1);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MaterialProformaBloc extends Bloc<MaterialProformaEvent, MaterialProformaState> {
  final GetMaterialProformasUseCase _materialProformaUseCase;
  DateTime? lastUpdated;

  MaterialProformaBloc(
      this._materialProformaUseCase)
      : super(const MaterialProformaInitial()) {
    on<GetMaterialProformas>(
      onGetMaterialProformas,
      transformer: throttleDroppable(throttleDuration),
    );
    // on<DeleteMaterialProformaEventLocal>(onDeleteMaterialProforma);
  }

  void onGetMaterialProformas(
      GetMaterialProformas event, Emitter<MaterialProformaState> emit) async {
    emit(const MaterialProformasLoading());
    debugPrint("onGetMaterialProformas, event: $event");

    final dataState = await _materialProformaUseCase(
        params: MaterialProformaParams(
      filterMaterialProformaInput: event.filterMaterialProformaInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
      mine: event.mine,
    ));
    if (dataState is DataSuccess) {
      if (event.mine == true) {
        final myMaterialProformas =
            (state.myMaterialProformas ?? MaterialProformaEntityListWithMeta.empty())
                .copyWith(
                    items: (state.myMaterialProformas?.items ?? [])
                      ..addAll(dataState.data!.items));

        emit(MaterialProformasSuccess(
            myMaterialProformas: myMaterialProformas,
            materialProformas: state.materialProformas ??
                MaterialProformaEntityListWithMeta.empty()));
      } else {
        final materialProformas =
            (state.materialProformas ?? MaterialProformaEntityListWithMeta.empty())
                .copyWith(
                    items: (state.materialProformas?.items ?? [])
                      ..addAll(dataState.data!.items));

        emit(MaterialProformasSuccess(
            materialProformas: materialProformas,
            myMaterialProformas: state.myMaterialProformas ??
                MaterialProformaEntityListWithMeta.empty()));
      }

      lastUpdated = DateTime.now();
    }

    if (dataState is DataFailed) {
      emit(MaterialProformasFailed(error: dataState.error!));
    }
  }


  void onDeleteMaterialProforma(
      DeleteMaterialProformaEventLocal event, Emitter<MaterialProformaState> emit) {
    final materialProformas = state.materialProformas;
    final myMaterialProformas = state.myMaterialProformas;
    final materialProformaId = event.materialProformaId;
    final isMine = event.isMine;

    emit(const MaterialProformasLoading());

    if (isMine == false && materialProformas != null) {
      final newMaterialProformas = materialProformas.copyWith(
          items: materialProformas.items
              .where((element) => element.id != materialProformaId)
              .toList());
      emit(MaterialProformasSuccess(
          materialProformas: newMaterialProformas.copyWith(
              items: newMaterialProformas.items, meta: newMaterialProformas.meta),
          myMaterialProformas:
              myMaterialProformas ?? MaterialProformaEntityListWithMeta.empty()));
    }

    if (isMine == true && myMaterialProformas != null) {
      final newMyMaterialProformas = myMaterialProformas.copyWith(
          items: myMaterialProformas.items
              .where((element) => element.id != materialProformaId)
              .toList());
      emit(MaterialProformasSuccess(
          myMaterialProformas: newMyMaterialProformas.copyWith(
              items: newMyMaterialProformas.items, meta: newMyMaterialProformas.meta),
          materialProformas:
              materialProformas ?? MaterialProformaEntityListWithMeta.empty()));
    }
  }
}
