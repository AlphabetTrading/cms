import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/projects/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/projects/data/models/project.dart';
import 'package:cms_mobile/features/projects/domain/repository/project_repository.dart';
import 'package:flutter/material.dart';

class ProjectRepositoryImpl extends ProjectRepository {
  final ProjectDataSource dataSource;

  ProjectRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<ProjectListWithMeta>> getProjects(
      FilterProjectInput? filterProjectInput,
      OrderByProjectInput? orderBy,
      PaginationInput? paginationInput) {
    debugPrint(
        'getProjects, filterProjectInput: $filterProjectInput, orderBy: $orderBy, paginationInput: $paginationInput');

    return dataSource.fetchProjects(
      filterProjectInput: filterProjectInput,
      orderBy: orderBy,
      paginationInput: paginationInput,
    );
  }

  @override
  Future<DataState<String>> selectProject(String id) {
    return dataSource.selectProject(id);
  }

  @override
  Future<DataState<String?>> getSelectedProject() {
    return dataSource.getSelectedProject();
  }
    @override
  Future<DataState<ProjectModel>> getProject({required String projectId}) {
    return dataSource.fetchProject(projectId: projectId);
  }

}
