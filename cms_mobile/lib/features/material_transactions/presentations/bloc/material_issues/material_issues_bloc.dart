import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/create_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_issue_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_issues.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialIssueBloc extends Bloc<MaterialIssueEvent, MaterialIssueState> {
  final GetMaterialIssuesUseCase _materialIssueUseCase;
  final CreateMaterialIssueUseCase _createMaterialIssueUseCase;
  final GetMaterialIssueDetailsUseCase _getMaterialIssueDetailsUseCase;


  MaterialIssueBloc(this._materialIssueUseCase,this._createMaterialIssueUseCase,this._getMaterialIssueDetailsUseCase)
      : super(const MaterialIssueInitial()) {
    on<GetMaterialIssues>(onGetMaterialIssues);
    on<CreateMaterialIssueEvent>(onCreateMaterialIssue);
    on<GetMaterialIssueDetailsEvent>(onGetMaterialIssueDetails);

  }

  void onGetMaterialIssues(
      GetMaterialIssues event, Emitter<MaterialIssueState> emit) async {
    debugPrint('onGetMaterialIssues');
    emit(const MaterialIssuesLoading());
    debugPrint('onGetMaterialIssues loading');
    debugPrint('onGetMaterialIssues event: ${event.filterMaterialIssueInput}');

    final dataState = await _materialIssueUseCase(
        params: MaterialIssueParams(
      filterMaterialIssueInput: event.filterMaterialIssueInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
    ));
    debugPrint('onGetMaterialIssues dataState: $dataState');
    if (dataState is DataSuccess) {
      emit(MaterialIssuesSuccess(materialIssues: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialIssuesFailed(error: dataState.error!));
    }
  }

    void onGetMaterialIssueDetails(
      GetMaterialIssueDetailsEvent event, Emitter<MaterialIssueState> emit) async {
   
    emit(const MaterialIssueDetailsLoading());

    final dataState = await _getMaterialIssueDetailsUseCase(
        params: event.materialIssueId
    );
    if (dataState is DataSuccess) {
      emit(MaterialIssueDetailsSuccess(materialIssue: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialIssueDetailsFailed(error: dataState.error!));
    }
  }

  void onCreateMaterialIssue(CreateMaterialIssueEvent event, Emitter<MaterialIssueState> emit) async {
    
    emit(CreateMaterialIssueLoading());
    final dataState = await _createMaterialIssueUseCase(
      params: event.createMaterialIssueParamsEntity
    );

    if (dataState is DataSuccess) {
      emit(CreateMaterialIssueSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateMaterialIssueFailed(error: dataState.error!));
    }

  }
}

