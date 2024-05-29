import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_issue_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialIssueDetailsState extends Equatable {
  const MaterialIssueDetailsState();

  @override
  List<Object> get props => [];
}

class MaterialIssueDetailsInitial extends MaterialIssueDetailsState {}

class MaterialIssueDetailsLoading extends MaterialIssueDetailsState {}

class MaterialIssueDetailsSuccess extends MaterialIssueDetailsState {
  final MaterialIssueEntity? materialIssue;

  const MaterialIssueDetailsSuccess({this.materialIssue});

  @override
  List<Object> get props => [materialIssue!];
}

class MaterialIssueDetailsFailed extends MaterialIssueDetailsState {
  final String error;

  const MaterialIssueDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialIssueDetailsEvent {}

class GetMaterialIssueDetailsEvent extends MaterialIssueDetailsEvent {
  final String materialIssueId;

  GetMaterialIssueDetailsEvent({required this.materialIssueId});
}

class MaterialIssueDetailsCubit extends Cubit<MaterialIssueDetailsState> {
  final GetMaterialIssueDetailsUseCase _getMaterialIssueDetailsUseCase;

  MaterialIssueDetailsCubit(this._getMaterialIssueDetailsUseCase)
      : super(MaterialIssueDetailsInitial());

  void onGetMaterialIssueDetails({required String materialIssueId}) async {
    emit(MaterialIssueDetailsLoading());
    final dataState =
        await _getMaterialIssueDetailsUseCase(params: materialIssueId);
    if (dataState is DataSuccess) {
      emit(MaterialIssueDetailsSuccess(
          materialIssue: dataState.data as MaterialIssueEntity));
    } else if (dataState is DataFailed) {
      emit(MaterialIssueDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material issue details'));
    }
  }
}
