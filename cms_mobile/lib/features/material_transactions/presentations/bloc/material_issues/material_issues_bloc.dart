import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialIssueBloc extends Bloc<MaterialIssueEvent, MaterialIssueState> {
  final GetMaterialIssuesUseCase _materialIssueUseCase;

  MaterialIssueBloc(this._materialIssueUseCase)
      : super(const MaterialIssueInitial()) {
    on<GetMaterialIssues>(onGetMaterialIssues);
  }

  void onGetMaterialIssues(
      GetMaterialIssues event, Emitter<MaterialIssueState> emit) async {
    debugPrint('onGetMaterialIssues');
    emit(const MaterialIssueLoading());
    debugPrint('onGetMaterialIssues loading');

    final dataState = await _materialIssueUseCase(
        params: MaterialIssueParams(
      filterMaterialIssueInput: event.filterMaterialIssueInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
    ));
    debugPrint('onGetMaterialIssues dataState: $dataState');
    if (dataState is DataSuccess) {
      emit(MaterialIssueSuccess(materialIssues: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialIssueFailed(error: dataState.error!));
    }
  }
}
