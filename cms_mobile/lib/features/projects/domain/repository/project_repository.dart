import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/project.dart';
import 'package:cms_mobile/features/projects/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/projects/data/models/project.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';

abstract class ProjectRepository {
  Future<DataState<ProjectListWithMeta>> getProjects(
    FilterProjectInput? filterProjectInput,
    OrderByProjectInput? orderBy,
    PaginationInput? paginationInput,
  );

  Future<DataState<String>> selectProject(String id);

  Future<DataState<String?>> getSelectedProject();

  Future<DataState<ProjectEntity>> getProject({required String projectId});

}
