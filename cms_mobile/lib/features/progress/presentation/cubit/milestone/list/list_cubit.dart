import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/usecases/get_milestones.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MilestonesState extends Equatable {
  const MilestonesState();

  @override
  List<Object> get props => [];
}

class MilestonesInitial extends MilestonesState {}

class MilestonesLoading extends MilestonesState {}

class MilestonesSuccess extends MilestonesState {
  final MilestoneEntityListWithMeta? milestoneEntityListWithMeta;

  const MilestonesSuccess({this.milestoneEntityListWithMeta});

  @override
  List<Object> get props => [milestoneEntityListWithMeta!];
}

class MilestonesFailed extends MilestonesState {
  final String error;

  const MilestonesFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MilestonesEvent {}

class GetMilestonesEvent extends MilestonesEvent {
  final GetMilestonesParamsEntity getMilestonesParamsEntity;

  GetMilestonesEvent({required this.getMilestonesParamsEntity});
}

class MilestonesCubit extends Cubit<MilestonesState> {
  final GetMilestonesUseCase _getMilestonesUseCase;

  MilestonesCubit(this._getMilestonesUseCase)
      : super(MilestonesInitial());

  void onGetMilestones({required  GetMilestonesParamsEntity getMilestonesParamsEntity}) async {
    emit(MilestonesLoading());
    final dataState =
        await _getMilestonesUseCase(params: getMilestonesParamsEntity);
    if (dataState is DataSuccess) {
      emit(MilestonesSuccess(
          milestoneEntityListWithMeta: dataState.data as MilestoneEntityListWithMeta));
    } else if (dataState is DataFailed) {
      emit(MilestonesFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get milestones'));
    }
  }
}
