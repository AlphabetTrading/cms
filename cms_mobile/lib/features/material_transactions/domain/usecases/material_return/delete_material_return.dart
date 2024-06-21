import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_return_repository.dart';

class DeleteMaterialReturnUseCase implements UseCase<String, String> {
  final MaterialReturnRepository repository;

  DeleteMaterialReturnUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.deleteMaterialReturn(
      materialReturnId: params!,
    );
  }
}

