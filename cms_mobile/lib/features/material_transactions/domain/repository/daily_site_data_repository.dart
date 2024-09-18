import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/daily_site_data/daily_site_data_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';

abstract class DailySiteDataRepository {
  Future<DataState<DailySiteDataListWithMeta>> getDailySiteDatas({
    FilterDailySiteDataInput? filterDailySiteDataInput,
    OrderByDailySiteDataInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  });

  Future<DataState<String>> createDailySiteData(
      {required CreateDailySiteDataParamsEntity params});

  Future<DataState<DailySiteDataEntity>> getDailySiteDataDetails(
      {required String params});

  Future<DataState<String>> editDailySiteData(
      {required EditDailySiteDataParamsEntity params});

  Future<DataState<String>> deleteDailySiteData(
      {required String dailySiteDataId});

  Future<DataState<String>> generateDailySiteDataPdf({required String id});
}
