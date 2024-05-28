import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_return_repository.dart';

class CreateMaterialReturnUseCase implements UseCase<String, CreateMaterialReturnParamsEntity> {
  final MaterialReturnRepository repository;

  CreateMaterialReturnUseCase(this.repository);

  @override
  Future<DataState<String>> call({CreateMaterialReturnParamsEntity? params}) async {
    return await repository.createMaterialReturn(
      params: params!,
    );
  }
}

