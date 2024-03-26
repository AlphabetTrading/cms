import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/materials/domain/entities/material.dart';
import 'package:cms_mobile/features/materials/domain/repository/material_repository.dart';

class GetMaterialsUseCase implements UseCase<List<MaterialEntity>, void> {
  final MaterialRepository repository;

  GetMaterialsUseCase(this.repository);

  @override
  Future<DataState<List<MaterialEntity>>> call({void params}) {
    return repository.getMaterials();
  }
}
