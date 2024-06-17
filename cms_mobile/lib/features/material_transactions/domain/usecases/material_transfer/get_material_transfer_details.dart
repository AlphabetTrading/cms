import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_transfer_repository.dart';

class GetMaterialTransferDetailsUseCase implements UseCase<MaterialTransferEntity, String> {
  final MaterialTransferRepository repository;

  GetMaterialTransferDetailsUseCase(this.repository);

  @override
  Future<DataState<MaterialTransferEntity>> call({String? params}) async {
    return await repository.getMaterialTransferDetails(
      params: params!,
    );
  }
}

