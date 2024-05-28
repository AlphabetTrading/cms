import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectState extends Equatable {
  final String? selectedProjectId;
  final ProjectEntityListWithMeta? projects;
  final Failure? error;

  const ProjectState({this.projects, this.error, this.selectedProjectId});

  @override
  List<Object?> get props => [projects, error];
}

class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

class ProjectIntialLoading extends ProjectState {
  const ProjectIntialLoading();
}

class ProjectLoading extends ProjectState {
  const ProjectLoading();
}



class ProjectSuccess extends ProjectState {
  const ProjectSuccess({required ProjectEntityListWithMeta projects})
      : super(projects: projects);
}



class ProjectFailed extends ProjectState {
  const ProjectFailed({required Failure error}) : super(error: error);
}

class ProjectEmpty extends ProjectState {
  const ProjectEmpty();
}

class ProjectSelected extends ProjectState {
  const ProjectSelected(
    String? selectedProjectId,
  ) : super(selectedProjectId: selectedProjectId);
}

class ProjectStateWithMeta extends ProjectState {
  const ProjectStateWithMeta({
    ProjectEntityListWithMeta? projects,
    String? selectedProjectId,
  }) : super(projects: projects, selectedProjectId: selectedProjectId);
}
