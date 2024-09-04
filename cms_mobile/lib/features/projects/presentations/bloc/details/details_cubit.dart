import 'package:cms_mobile/features/projects/domain/entities/project.dart';
import 'package:cms_mobile/features/projects/domain/usecases/get_project_detail_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProjectDetailsState extends Equatable {
  const ProjectDetailsState();

  @override
  List<Object> get props => [];
}



class ProjectDetailsInitial extends ProjectDetailsState {}

class ProjectDetailsLoading extends ProjectDetailsState {}

class ProjectDetailsSuccess extends ProjectDetailsState {
  final ProjectEntity project;

  const ProjectDetailsSuccess({required this.project});

  @override
  List<Object> get props => [project];
}

class ProjectDetailsFailed extends ProjectDetailsState {
  final String error;

  const ProjectDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class ProjectDetailsEvent {}

class GetProjectDetailsEvent extends ProjectDetailsEvent {
  final String projectId;

  GetProjectDetailsEvent({required this.projectId});
}

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  final GetProjectDetailsUseCase _getProjectDetailsUseCase;

  ProjectDetailsCubit(this._getProjectDetailsUseCase)
      : super(ProjectDetailsInitial());

  void onGetProjectDetails({required String projectId}) async {
    emit(ProjectDetailsLoading());
    final dataState =
        await _getProjectDetailsUseCase(params: projectId);
    if (dataState is DataSuccess) {
      emit(ProjectDetailsSuccess(
          project: dataState.data as ProjectEntity));
    } else if (dataState is DataFailed) {
      emit(ProjectDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material issue details'));
    }
  }
}
