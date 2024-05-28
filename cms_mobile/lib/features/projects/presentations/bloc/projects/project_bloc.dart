import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/projects/domain/usecases/get_project_issue.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_event.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetProjectsUseCase _projectUseCase;
  final GetSelectedProjectUseCase _getSelectedProjectUseCase;
  final SelectProjectUseCase _selectedProjectUseCase;

  ProjectBloc(
    this._projectUseCase,
    this._getSelectedProjectUseCase,
    this._selectedProjectUseCase,
  ) : super(const ProjectInitial()) {
    on<GetSelectedProject>(onGetSelectedProject);
    on<GetProjects>(onGetProjects);
    on<SelectProject>(onSelectProject);
    on<LoadProjects>(onLoadProjects);
  }

  void onLoadProjects(LoadProjects event, Emitter<ProjectState> emit) async {
    emit(const ProjectIntialLoading());
    final dataState = await _projectUseCase(params: ProjectParams());
    if (dataState is DataSuccess) {
      emit(ProjectSuccess(projects: dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(ProjectFailed(error: dataState.error!));
    }
  }

  void onGetProjects(GetProjects event, Emitter<ProjectState> emit) async {
    debugPrint("LoadProjects init");
    emit(const ProjectLoading());
    final dataState = await _projectUseCase(
        params: ProjectParams(
      filterProjectInput: event.filterProjectInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
    ));
    debugPrint("LoadProjects dataState: $dataState");
    if (dataState is DataSuccess) {
      final selectedProjectState = await _getSelectedProjectUseCase();
      if (selectedProjectState is DataSuccess) {
        if (selectedProjectState.data == null ||
            dataState.data!.items.isEmpty) {
          // emit(ProjectSelected(dataState.data!.items.first.id!));
          final selectedProjectId = dataState.data!.items.first.id!;

          emit(ProjectStateWithMeta(
              projects: dataState.data!, selectedProjectId: selectedProjectId));

          final selectedDataState =
              await _selectedProjectUseCase(params: selectedProjectId);

          if (selectedDataState is DataSuccess) {
            debugPrint("selectedDataState: ${selectedDataState.data}");
          } else {
            debugPrint("selectedDataState: ${selectedDataState.error}");
          }
        } else {
          emit(ProjectStateWithMeta(
              projects: dataState.data!,
              selectedProjectId: selectedProjectState.data!));
        }
      } else {
        emit(ProjectSuccess(projects: dataState.data!));
      }
    }
    if (dataState is DataFailed) {
      emit(ProjectFailed(error: dataState.error!));
    }
  }

  void onGetSelectedProject(
      GetSelectedProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectLoading());
    final dataState = await _getSelectedProjectUseCase();
    if (dataState is DataSuccess) {
      emit(ProjectSelected(dataState.data!));
    }
  }

  void onSelectProject(SelectProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectIntialLoading());

    final dataState = await _selectedProjectUseCase(params: event.id);
    if (dataState is DataSuccess) {
      emit(ProjectStateWithMeta(
          selectedProjectId: dataState.data, projects: event.projects));
    } else {
      emit(ProjectFailed(error: dataState.error!));
    }
  }
}
