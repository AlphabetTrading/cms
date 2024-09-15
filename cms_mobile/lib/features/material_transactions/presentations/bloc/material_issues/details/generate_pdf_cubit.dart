import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/generate_material_issue_pdf.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/get_material_issue_details.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialIssueGeneratePdfState extends Equatable {
  const MaterialIssueGeneratePdfState();

  @override
  List<Object> get props => [];
}

class MaterialIssueGeneratePdfInitial extends MaterialIssueGeneratePdfState {}

class MaterialIssueGeneratePdfLoading extends MaterialIssueGeneratePdfState {}

class MaterialIssueGeneratePdfSuccess extends MaterialIssueGeneratePdfState {
  final String materialIssue;

  const MaterialIssueGeneratePdfSuccess({required this.materialIssue});

  @override
  List<Object> get props => [materialIssue];
}

class MaterialIssueGeneratePdfFailed extends MaterialIssueGeneratePdfState {
  final String error;

  const MaterialIssueGeneratePdfFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialIssueGeneratePdfEvent {}

class GetMaterialIssueGeneratePdfEvent extends MaterialIssueGeneratePdfEvent {
  final String materialIssueId;

  GetMaterialIssueGeneratePdfEvent({required this.materialIssueId});
}

class MaterialIssueGeneratePdfCubit extends Cubit<MaterialIssueGeneratePdfState> {
  final GenerateMaterialIssuePdfUseCase _generateMaterialIssuePdfUseCase;

  MaterialIssueGeneratePdfCubit(this._generateMaterialIssuePdfUseCase)
      : super(MaterialIssueGeneratePdfInitial());

  Future<void> onGetMaterialIssueGeneratePdf({required String materialIssueId}) async {
    emit(MaterialIssueGeneratePdfLoading());
    final dataState =
        await _generateMaterialIssuePdfUseCase(params: materialIssueId);

    if (dataState is DataSuccess) {
      emit(MaterialIssueGeneratePdfSuccess(
          materialIssue: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(MaterialIssueGeneratePdfFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material issue pdf'));
    }
  }
}
