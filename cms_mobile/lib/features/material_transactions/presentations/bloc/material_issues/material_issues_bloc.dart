import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/approve_material_issue.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/create_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/get_material_issues.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const throttleDuration = Duration(seconds: 1);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MaterialIssueBloc extends Bloc<MaterialIssueEvent, MaterialIssueState> {
  final GetMaterialIssuesUseCase _materialIssueUseCase;
  final CreateMaterialIssueUseCase _createMaterialIssueUseCase;
  final ApproveMaterialIssueUseCase _approveMaterialIssueUseCase;
  DateTime? lastUpdated;

  MaterialIssueBloc(this._materialIssueUseCase,
      this._createMaterialIssueUseCase, this._approveMaterialIssueUseCase)
      : super(const MaterialIssueInitial()) {
    on<GetMaterialIssues>(
      onGetMaterialIssues,
      transformer: throttleDroppable(throttleDuration),
    );
    on<CreateMaterialIssueEvent>(onCreateMaterialIssue);
    on<ApproveMaterialIssueEvent>(onApproveMaterialIssue);
    on<DeleteMaterialIssueEventLocal>(onDeleteMaterialIssue);
  }

  void onGetMaterialIssues(
      GetMaterialIssues event, Emitter<MaterialIssueState> emit) async {
    emit(const MaterialIssuesLoading());
    debugPrint("onGetMaterialIssues, event: $event");

    final dataState = await _materialIssueUseCase(
        params: MaterialIssueParams(
      filterMaterialIssueInput: event.filterMaterialIssueInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
      mine: event.mine,
    ));
    if (dataState is DataSuccess) {
      if (event.mine == true) {
        final myMaterialIssues =
            (state.myMaterialIssues ?? MaterialIssueEntityListWithMeta.empty())
                .copyWith(
                    items: (state.myMaterialIssues?.items ?? [])
                      ..addAll(dataState.data!.items));

        emit(MaterialIssuesSuccess(
            myMaterialIssues: myMaterialIssues,
            materialIssues: state.materialIssues ??
                MaterialIssueEntityListWithMeta.empty()));
      } else {
        final materialIssues =
            (state.materialIssues ?? MaterialIssueEntityListWithMeta.empty())
                .copyWith(
                    items: (state.materialIssues?.items ?? [])
                      ..addAll(dataState.data!.items));

        emit(MaterialIssuesSuccess(
            materialIssues: materialIssues,
            myMaterialIssues: state.myMaterialIssues ??
                MaterialIssueEntityListWithMeta.empty()));
      }

      lastUpdated = DateTime.now();
    }

    if (dataState is DataFailed) {
      emit(MaterialIssuesFailed(error: dataState.error!));
    }
  }

  void onCreateMaterialIssue(
      CreateMaterialIssueEvent event, Emitter<MaterialIssueState> emit) async {
    emit(const CreateMaterialIssueLoading());

    final dataState = await _createMaterialIssueUseCase(
        params: event.createMaterialIssueParamsEntity);

    if (dataState is DataSuccess) {
      emit(const CreateMaterialIssueSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateMaterialIssueFailed(error: dataState.error!));
    }
  }

  void onDeleteMaterialIssue(
      DeleteMaterialIssueEventLocal event, Emitter<MaterialIssueState> emit) {
    final materialIssues = state.materialIssues;
    final myMaterialIssues = state.myMaterialIssues;
    final materialIssueId = event.materialIssueId;
    final isMine = event.isMine;

    emit(const MaterialIssuesLoading());

    if (isMine == false && materialIssues != null) {
      final newMaterialIssues = materialIssues.copyWith(
          items: materialIssues.items
              .where((element) => element.id != materialIssueId)
              .toList());
      emit(MaterialIssuesSuccess(
          materialIssues: newMaterialIssues.copyWith(
              items: newMaterialIssues.items, meta: newMaterialIssues.meta),
          myMaterialIssues:
              myMaterialIssues ?? MaterialIssueEntityListWithMeta.empty()));
    }

    if (isMine == true && myMaterialIssues != null) {
      final newMyMaterialIssues = myMaterialIssues.copyWith(
          items: myMaterialIssues.items
              .where((element) => element.id != materialIssueId)
              .toList());
      emit(MaterialIssuesSuccess(
          myMaterialIssues: newMyMaterialIssues.copyWith(
              items: newMyMaterialIssues.items, meta: newMyMaterialIssues.meta),
          materialIssues:
              materialIssues ?? MaterialIssueEntityListWithMeta.empty()));
    }
  }

  void onApproveMaterialIssue(
      ApproveMaterialIssueEvent event, Emitter<MaterialIssueState> emit) async {
    emit(const ApproveMaterialIssueLoading());

    final dataState = await _approveMaterialIssueUseCase(
        params: ApproveMaterialIssueParamsModel(
            decision: event.decision, materialIssueId: event.materialIssueId));

    debugPrint('Response: $dataState');
    
    if (dataState is DataSuccess) {
      emit(const ApproveMaterialIssueSuccess());
    }

    if (dataState is DataFailed) {
      emit(ApproveMaterialIssueFailed(error: dataState.error!));
    }
  }
}
