import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_return/material_return_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_return_repository.dart';

class GetMaterialReturnUseCase
    implements UseCase<MaterialReturnListWithMeta, GetMaterialReturnParams?> {
  final MaterialReturnRepository _materialTransactionRepository;

  GetMaterialReturnUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<MaterialReturnListWithMeta>> call({
    GetMaterialReturnParams? params,
  }) {
    return _materialTransactionRepository.getMaterialReturns(
      filterMaterialReturnInput: params?.filterMaterialReturnInput,
      orderBy: params?.orderBy,
      paginationInput: params?.paginationInput,
    );
  }
}

class GetMaterialReturnParams {
  FilterMaterialReturnInput? filterMaterialReturnInput;
  OrderByMaterialReturnInput? orderBy;
  PaginationInput? paginationInput;
  bool? mine;

  GetMaterialReturnParams({
    this.filterMaterialReturnInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}
