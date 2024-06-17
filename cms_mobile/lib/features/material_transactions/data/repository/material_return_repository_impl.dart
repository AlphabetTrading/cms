import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_return/material_return_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_return_repository.dart';

class MaterialReturnRepositoryImpl extends MaterialReturnRepository {
  final MaterialReturnDataSource dataSource;

  MaterialReturnRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<String>> createMaterialReturn(
      {required CreateMaterialReturnParamsEntity params}) {
    return dataSource.createMaterialReturn(
        createMaterialReturnParamsModel:
            CreateMaterialReturnParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<MaterialReturnListWithMeta>> getMaterialReturns(
      {FilterMaterialReturnInput? filterMaterialReturnInput,
      OrderByMaterialReturnInput? orderBy,
      PaginationInput? paginationInput}) {
    return dataSource.fetchMaterialReturns(
      filterMaterialReturnInput: filterMaterialReturnInput,
      orderBy: orderBy,
      paginationInput: paginationInput,
    );
  }
}
