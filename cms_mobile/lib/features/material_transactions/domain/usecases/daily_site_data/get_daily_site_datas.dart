import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/daily_site_data/daily_site_data_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/daily_site_data_repository.dart';

class GetDailySiteDatasUseCase
    implements UseCase<DailySiteDataEntityListWithMeta, DailySiteDataParams?> {
  final DailySiteDataRepository _materialTransactionRepository;

  GetDailySiteDatasUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<DailySiteDataEntityListWithMeta>> call(
      {DailySiteDataParams? params}) {
    print("from daily usecase: ${params?.filterDailySiteDataInput}");

    return _materialTransactionRepository.getDailySiteDatas(
      filterDailySiteDataInput: params!.filterDailySiteDataInput,
      orderBy: params.orderBy,
      paginationInput: params.paginationInput,
      mine: params.mine,
    );
  }
}

class DailySiteDataParams {
  FilterDailySiteDataInput? filterDailySiteDataInput;
  OrderByDailySiteDataInput? orderBy;
  PaginationInput? paginationInput;
  bool? mine;

  DailySiteDataParams({
    this.filterDailySiteDataInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}
