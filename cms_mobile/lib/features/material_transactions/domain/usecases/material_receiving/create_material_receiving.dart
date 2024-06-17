import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_receive_repository.dart';

class CreateMaterialReceiveUseCase
    implements UseCase<String, CreateMaterialReceiveParamsEntity> {
  final MaterialReceiveRepository repository;

  CreateMaterialReceiveUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {CreateMaterialReceiveParamsEntity? params}) async {
    return await repository.createMaterialReceive(
      params: params!,
    );
  }
}
