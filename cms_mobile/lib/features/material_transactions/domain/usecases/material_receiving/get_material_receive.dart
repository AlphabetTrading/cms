import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_receive_repository.dart';

class GetMaterialReceivesUseCase
    implements
        UseCase<MaterialReceiveEntityListWithMeta, MaterialReceiveParams?> {
  final MaterialReceiveRepository _materialReceiveRepository;

  GetMaterialReceivesUseCase(this._materialReceiveRepository);

  @override
  Future<DataState<MaterialReceiveEntityListWithMeta>> call(
      {MaterialReceiveParams? params}) {
    return _materialReceiveRepository.getMaterialReceivings(
      params!.filterMaterialReceiveInput,
      params.orderBy,
      params.paginationInput,
    );
  }
}

class MaterialReceiveParams {
  FilterMaterialReceiveInput? filterMaterialReceiveInput;
  OrderByMaterialReceiveInput? orderBy;
  PaginationInput? paginationInput;

  MaterialReceiveParams({
    this.filterMaterialReceiveInput,
    this.orderBy,
    this.paginationInput,
  });
}
