import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_receive_repository.dart';

class EditMaterialReceiveUseCase
    implements UseCase<String, String> {
  final MaterialReceiveRepository repository;

  EditMaterialReceiveUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {String? params}) async {
    return await repository.editMaterialReceive(
      params: params!,
    );
  }
}
