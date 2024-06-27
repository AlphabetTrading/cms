//state
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/usecases/create_milestone.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreateMilestoneState extends Equatable {
  const CreateMilestoneState();

  @override
  List<Object> get props => [];
}

class CreateMilestoneInitial extends CreateMilestoneState {}

class CreateMilestoneLoading extends CreateMilestoneState {}

class CreateMilestoneSuccess extends CreateMilestoneState {
  const CreateMilestoneSuccess();
}

class CreateMilestoneFailed extends CreateMilestoneState {
  final String error;

  const CreateMilestoneFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
class CreateMilestoneEvent {
  final CreateMilestoneParamsEntity createMilestoneInput;

  CreateMilestoneEvent({required this.createMilestoneInput});
}

//cubit
class CreateMilestoneCubit extends Cubit<CreateMilestoneState> {
  final CreateMilestoneUseCase _materialIssueDeleteUseCase;

  CreateMilestoneCubit(this._materialIssueDeleteUseCase)
      : super(CreateMilestoneInitial());

  void onCreateMilestone(
      {required CreateMilestoneParamsEntity params}) async {
    emit(CreateMilestoneLoading());
    final dataState = await _materialIssueDeleteUseCase(params: params);
    if (dataState is DataSuccess) {
      emit(CreateMilestoneSuccess());
    } else if (dataState is DataFailed) {
      emit(CreateMilestoneFailed(
          error:
              dataState.error?.errorMessage ?? 'Failed to create milestone '));
    }
  }
}
