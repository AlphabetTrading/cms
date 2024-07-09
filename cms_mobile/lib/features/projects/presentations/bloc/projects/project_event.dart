import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/projects/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';

abstract class ProjectEvent {
  const ProjectEvent();
}

class LoadProjects extends ProjectEvent {
  const LoadProjects();
}

class GetProjects extends ProjectEvent {
  final FilterProjectInput? filterProjectInput;
  final OrderByProjectInput? orderBy;
  final PaginationInput? paginationInput;
  const GetProjects({
    this.filterProjectInput,
    this.orderBy,
    this.paginationInput,
  });
}

class GetProject extends ProjectEvent {
  final FilterProjectInput filterProjectInput;
  final OrderByProjectInput orderBy;
  final PaginationInput paginationInput;
  const GetProject(
    this.filterProjectInput,
    this.orderBy,
    this.paginationInput,
  );
}

class CreateProject extends ProjectEvent {
  final String id;
  const CreateProject(this.id);
}

class UpdateProject extends ProjectEvent {
  final String id;
  const UpdateProject(this.id);
}

class DeleteProject extends ProjectEvent {
  final String id;
  const DeleteProject(this.id);
}

class SelectProject extends ProjectEvent {
  final String id;
  final ProjectEntityListWithMeta projects;
  const SelectProject(this.id, this.projects);
}

class GetSelectedProject extends ProjectEvent {
  const GetSelectedProject();
}
