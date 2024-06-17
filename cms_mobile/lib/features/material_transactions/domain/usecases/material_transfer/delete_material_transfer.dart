import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_transfer_repository.dart';

class DeleteMaterialTransferUseCase implements UseCase<String, String> {
  final MaterialTransferRepository repository;

  DeleteMaterialTransferUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.deleteMaterialTransfer(
      materialId: params!,
    );
  }
}

