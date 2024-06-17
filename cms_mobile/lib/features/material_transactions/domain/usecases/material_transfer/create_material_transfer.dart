import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_transfer_repository.dart';

class CreateMaterialTransferUseCase implements UseCase<String, CreateMaterialTransferParamsEntity> {
  final MaterialTransferRepository repository;

  CreateMaterialTransferUseCase(this.repository);

  @override
  Future<DataState<String>> call({CreateMaterialTransferParamsEntity? params}) async {
    return await repository.createMaterialTransfer(
      params: params!,
    );
  }
}

