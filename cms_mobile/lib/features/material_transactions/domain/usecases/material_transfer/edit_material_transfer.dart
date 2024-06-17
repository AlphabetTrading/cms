import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_transfer_repository.dart';

class EditMaterialTransferUseCase
    implements UseCase<String, EditMaterialTransferParamsEntity> {
  final MaterialTransferRepository repository;

  EditMaterialTransferUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {EditMaterialTransferParamsEntity? params}) async {
    return await repository.editMaterialTransfer(
      params: params!,
    );
  }
}
