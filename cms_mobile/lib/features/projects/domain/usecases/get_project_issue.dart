import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/projects/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/projects/data/models/project.dart';
import 'package:cms_mobile/features/projects/domain/repository/project_repository.dart';

class GetProjectsUseCase
    implements UseCase<ProjectListWithMeta, ProjectParams?> {
  final ProjectRepository _projectRepository;

  GetProjectsUseCase(this._projectRepository);

  @override
  Future<DataState<ProjectListWithMeta>> call({ProjectParams? params}) {
    return _projectRepository.getProjects(
      params!.filterProjectInput,
      params.orderBy,
      params.paginationInput,
    );
  }
}

class SelectProjectUseCase implements UseCase<String, String?> {
  final ProjectRepository _projectRepository;

  SelectProjectUseCase(this._projectRepository);

  @override
  Future<DataState<String>> call({String? params}) {
    return _projectRepository.selectProject(params!);
  }
}

class GetSelectedProjectUseCase implements UseCase<String?, void> {
  final ProjectRepository _projectRepository;

  GetSelectedProjectUseCase(this._projectRepository);

  @override
  Future<DataState<String?>> call({void params}) {
    return _projectRepository.getSelectedProject();
  }
}

class ProjectParams {
  FilterProjectInput? filterProjectInput;
  OrderByProjectInput? orderBy;
  PaginationInput? paginationInput;

  ProjectParams({
    this.filterProjectInput,
    this.orderBy,
    this.paginationInput,
  });
}
