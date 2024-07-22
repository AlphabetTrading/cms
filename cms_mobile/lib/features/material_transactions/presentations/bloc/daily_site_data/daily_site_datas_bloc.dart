import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/create_daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/get_daily_site_datas.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_state.dart';
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

class DailySiteDataBloc extends Bloc<DailySiteDataEvent, DailySiteDataState> {
  final GetDailySiteDatasUseCase _dailySiteDataUseCase;
  final CreateDailySiteDataUseCase _createDailySiteDataUseCase;
  DateTime? lastUpdated;

  DailySiteDataBloc(
      this._dailySiteDataUseCase, this._createDailySiteDataUseCase)
      : super(const DailySiteDataInitial()) {
    on<GetDailySiteDatas>(
      onGetDailySiteDatas,
      transformer: throttleDroppable(throttleDuration),
    );
    on<CreateDailySiteDataEvent>(onCreateDailySiteData);
    on<DeleteDailySiteDataEventLocal>(onDeleteDailySiteData);
  }

  void onGetDailySiteDatas(
      GetDailySiteDatas event, Emitter<DailySiteDataState> emit) async {
    emit(const DailySiteDatasLoading());
    debugPrint("onGetDailySiteDatas, event: ${event.filterDailySiteDataInput}");

    final dataState = await _dailySiteDataUseCase(
        params: DailySiteDataParams(
      filterDailySiteDataInput: event.filterDailySiteDataInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
      mine: event.mine,
    ));
    if (dataState is DataSuccess) {
      if (event.mine == true) {
        final myDailySiteDatas =
            (state.myDailySiteDatas ?? DailySiteDataEntityListWithMeta.empty())
                .copyWith(
                    items: (state.myDailySiteDatas?.items ?? [])
                      ..addAll(dataState.data!.items));

        emit(DailySiteDatasSuccess(
            myDailySiteDatas: myDailySiteDatas,
            dailySiteDatas: state.dailySiteDatas ??
                DailySiteDataEntityListWithMeta.empty()));
      } else {
        final dailySiteDatas =
            (state.dailySiteDatas ?? DailySiteDataEntityListWithMeta.empty())
                .copyWith(
                    items: (state.dailySiteDatas?.items ?? [])
                      ..addAll(dataState.data!.items));

        emit(DailySiteDatasSuccess(
            dailySiteDatas: dailySiteDatas,
            myDailySiteDatas: state.myDailySiteDatas ??
                DailySiteDataEntityListWithMeta.empty()));
      }

      lastUpdated = DateTime.now();
    }

    if (dataState is DataFailed) {
      emit(DailySiteDatasFailed(error: dataState.error!));
    }
  }

  void onCreateDailySiteData(
      CreateDailySiteDataEvent event, Emitter<DailySiteDataState> emit) async {
    emit(const CreateDailySiteDataLoading());

    final dataState = await _createDailySiteDataUseCase(
        params: event.createDailySiteDataParamsEntity);

    if (dataState is DataSuccess) {
      emit(const CreateDailySiteDataSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateDailySiteDataFailed(error: dataState.error!));
    }
  }

  void onDeleteDailySiteData(
      DeleteDailySiteDataEventLocal event, Emitter<DailySiteDataState> emit) {
    final dailySiteDatas = state.dailySiteDatas;
    final myDailySiteDatas = state.myDailySiteDatas;
    final dailySiteDataId = event.dailySiteDataId;
    final isMine = event.isMine;

    emit(const DailySiteDatasLoading());

    if (isMine == false && dailySiteDatas != null) {
      final newDailySiteDatas = dailySiteDatas.copyWith(
          items: dailySiteDatas.items
              .where((element) => element.id != dailySiteDataId)
              .toList());
      emit(DailySiteDatasSuccess(
          dailySiteDatas: newDailySiteDatas.copyWith(
              items: newDailySiteDatas.items, meta: newDailySiteDatas.meta),
          myDailySiteDatas:
              myDailySiteDatas ?? DailySiteDataEntityListWithMeta.empty()));
    }

    if (isMine == true && myDailySiteDatas != null) {
      final newMyDailySiteDatas = myDailySiteDatas.copyWith(
          items: myDailySiteDatas.items
              .where((element) => element.id != dailySiteDataId)
              .toList());
      emit(DailySiteDatasSuccess(
          myDailySiteDatas: newMyDailySiteDatas.copyWith(
              items: newMyDailySiteDatas.items, meta: newMyDailySiteDatas.meta),
          dailySiteDatas:
              dailySiteDatas ?? DailySiteDataEntityListWithMeta.empty()));
    }
  }
}
