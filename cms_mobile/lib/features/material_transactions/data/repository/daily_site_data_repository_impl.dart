import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/daily_site_data/daily_site_data_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/daily_site_data_repository.dart';

class DailySiteDataRepositoryImpl extends DailySiteDataRepository {
  final DailySiteDataDataSource dataSource;

  DailySiteDataRepositoryImpl({required this.dataSource});

  // @override
  // Future<DataState<DailySiteDataEntityListWithMeta>> getDailySiteDatas(
  //     {FilterDailySiteDataInput? filterDailySiteDataInput,
  //     OrderByDailySiteDataInput? orderBy,
  //     PaginationInput? paginationInput,
  //     bool? mine}) {
  //   return dataSource.fetchDailySiteDatas(
  //     filterDailySiteDataInput: filterDailySiteDataInput,
  //     orderBy: orderBy,
  //     paginationInput: paginationInput,
  //     mine: mine,
  //   );
  // }

  @override
  Future<DataState<String>> createDailySiteData(
      {required CreateDailySiteDataParamsEntity params}) {
    return dataSource.createDailySiteData(
        createDailySiteDataParamsModel:
            CreateDailySiteDataParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<String>> editDailySiteData(
      {required EditDailySiteDataParamsEntity params}) {
    return dataSource.editDailySiteData(
        editDailySiteDataParamsModel:
            EditDailySiteDataParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<String>> deleteDailySiteData(
      {required String dailySiteDataId}) {
    return dataSource.deleteDailySiteData(dailySiteDataId: dailySiteDataId);
  }

  @override
  Future<DataState<DailySiteDataEntity>> getDailySiteDataDetails(
      {required String params}) {
    return dataSource.getDailySiteDataDetails(params: params);
  }

  @override
  Future<DataState<DailySiteDataListWithMeta>> getDailySiteDatas(
      {FilterDailySiteDataInput? filterDailySiteDataInput,
      OrderByDailySiteDataInput? orderBy,
      PaginationInput? paginationInput,
      bool? mine}) {
    return dataSource.fetchDailySiteDatas(
      filterDailySiteDataInput: filterDailySiteDataInput,
      orderBy: orderBy,
      paginationInput: paginationInput,
      mine: mine,
    );
  }
}

 // @override
  // Future<DataState<DailySiteDataModel>> getDailySiteDataDetails(
  //     {required String params}) {
  //   return dataSource.getDailySiteDataDetails(params: params);
  // }