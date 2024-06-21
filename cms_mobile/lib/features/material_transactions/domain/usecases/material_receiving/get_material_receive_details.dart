import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_receive_repository.dart';

class GetMaterialReceiveDetailsUseCase
    implements UseCase<MaterialReceiveEntity, String> {
  final MaterialReceiveRepository repository;

  GetMaterialReceiveDetailsUseCase(this.repository);

  @override
  Future<DataState<MaterialReceiveEntity>> call({String? params}) async {
    return await repository.getMaterialReceiveDetails(
      params: params!,
    );
  }
}
