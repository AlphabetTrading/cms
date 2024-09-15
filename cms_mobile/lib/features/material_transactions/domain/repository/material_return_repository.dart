import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_return/material_return_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';

abstract class MaterialReturnRepository {
  Future<DataState<MaterialReturnListWithMeta>> getMaterialReturns({
    FilterMaterialReturnInput? filterMaterialReturnInput,
    OrderByMaterialReturnInput? orderBy,
    PaginationInput? paginationInput,
  });
  Future<DataState<String>> deleteMaterialReturn(
      {required String materialReturnId});
  Future<DataState<MaterialReturnEntity>> getMaterialReturnDetails(
      {required String params});

  Future<DataState<String>> createMaterialReturn(
      {required CreateMaterialReturnParamsEntity params});

  Future<DataState<String>> generateMaterialReturnPdf({required String id});
}
