import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/get_material_issue_details.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/usecases/get_milestone_details.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MilestoneDetailsState extends Equatable {
  const MilestoneDetailsState();

  @override
  List<Object> get props => [];
}

class MilestoneDetailsInitial extends MilestoneDetailsState {}

class MilestoneDetailsLoading extends MilestoneDetailsState {}

class MilestoneDetailsSuccess extends MilestoneDetailsState {
  final MilestoneEntity? milestone;

  const MilestoneDetailsSuccess({this.milestone});

  @override
  List<Object> get props => [milestone!];
}

class MilestoneDetailsFailed extends MilestoneDetailsState {
  final String error;

  const MilestoneDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MilestoneDetailsEvent {}

class GetMilestoneDetailsEvent extends MilestoneDetailsEvent {
  final String milestoneId;

  GetMilestoneDetailsEvent({required this.milestoneId});
}

class MilestoneDetailsCubit extends Cubit<MilestoneDetailsState> {
  final GetMilestoneDetailsUseCase _getMilestoneDetailsUseCase;

  MilestoneDetailsCubit(this._getMilestoneDetailsUseCase)
      : super(MilestoneDetailsInitial());

  void onGetMilestoneDetails({required String milestoneId}) async {
    emit(MilestoneDetailsLoading());
    final dataState =
        await _getMilestoneDetailsUseCase(params: milestoneId);
    if (dataState is DataSuccess) {
      emit(MilestoneDetailsSuccess(
          milestone: dataState.data as MilestoneEntity));
    } else if (dataState is DataFailed) {
      emit(MilestoneDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get milestone details'));
    }
  }
}
