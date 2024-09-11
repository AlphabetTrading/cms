import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_proformas/material_proforma_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';

abstract class MaterialProformaRepository {
  Future<DataState<MaterialProformaListWithMeta>> getMaterialProformas(
    FilterMaterialProformaInput? filterMaterialProformaInput,
    OrderByMaterialProformaInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  );

  Future<DataState<String>> createMaterialProforma(
      {required CreateMaterialProformaParamsEntity params});

  Future<DataState<MaterialProformaEntity>> getMaterialProformaDetails(
      {required String params});

  Future<DataState<String>> editMaterialProforma(
      {required EditMaterialProformaParamsEntity params});

  Future<DataState<String>> deleteMaterialProforma(
      {required String materialProformaId});

  Future<DataState<List<MaterialProformaEntity>>> getAllMaterialProformas(
      FilterMaterialProformaInput? filterMaterialProformaInput);
}
