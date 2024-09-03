
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';
import 'package:cms_mobile/features/projects/domain/repository/project_repository.dart';

class GetProjectDetailsUseCase implements UseCase<ProjectEntity, String> {
  final ProjectRepository repository;

  GetProjectDetailsUseCase(this.repository);

  @override
  Future<DataState<ProjectEntity>> call({String? params}) async {
    return await repository.getProject(
      projectId: params!,
    );
  }
}

