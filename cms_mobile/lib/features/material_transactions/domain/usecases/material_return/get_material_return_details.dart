
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_return_repository.dart';

class GetMaterialReturnDetailsUseCase implements UseCase<MaterialReturnEntity, String> {
  final MaterialReturnRepository repository;

  GetMaterialReturnDetailsUseCase(this.repository);

  @override
  Future<DataState<MaterialReturnEntity>> call({String? params}) async {
    return await repository.getMaterialReturnDetails(
      params: params!,
    );
  }
}

