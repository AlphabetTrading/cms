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
  }

  void onGetProjects(GetProjects event, Emitter<ProjectState> emit) async {
    debugPrint('onGetProjects');
    emit(const ProjectLoading());
    debugPrint('onGetProjects loading');

    final dataState = await _projectUseCase(
        params: ProjectParams(
      filterProjectInput: event.filterProjectInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
    ));
    debugPrint('onGetProjects dataState: $dataState');
    if (dataState is DataSuccess) {
      // final selectedProjectState = await _getSelectedProjectUseCase();
      // if (selectedProjectState is DataSuccess) {
      //   if (selectedProjectState.data == null ||
      //       dataState.data!.items.isEmpty) {
      //     emit(ProjectSelected(dataState.data!.items.first.id!));
      //     // add(SelectProject(dataState.data!.items.first.id!));
      //   }
      // }
      emit(ProjectSuccess(projects: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(ProjectFailed(error: dataState.error!));
    }
  }

  void onGetSelectedProject(
      GetSelectedProject event, Emitter<ProjectState> emit) async {
    final dataState = await _getSelectedProjectUseCase();
    if (dataState is DataSuccess) {
      emit(ProjectSelected(dataState.data!));
    }
  }

  void onSelectProject(SelectProject event, Emitter<ProjectState> emit) async {
    final dataState = await _selectedProjectUseCase(params: event.id);
    debugPrint('onSelectProject dataState: ${dataState}, id: ${event.id}');

    if (dataState is DataSuccess) {
      emit(ProjectSelected(dataState.data));
    } else {
      emit(ProjectFailed(error: dataState.error!));
    }
  }
}
