import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_proformas/material_proforma_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_proforma_repository.dart';
import 'package:flutter/material.dart';

class MaterialProformaRepositoryImpl extends MaterialProformaRepository {
  final MaterialProformaDataSource dataSource;

  MaterialProformaRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<MaterialProformaListWithMeta>> getMaterialProformas(
      FilterMaterialProformaInput? filterMaterialProformaInput,
      OrderByMaterialProformaInput? orderBy,
      PaginationInput? paginationInput,
      bool? mine) {
    debugPrint(
        'getMaterialProformas, filterMaterialProformaInput: $filterMaterialProformaInput, orderBy: $orderBy, paginationInput: $paginationInput');

    return dataSource.fetchMaterialProformas(
      filterMaterialProformaInput: filterMaterialProformaInput,
      orderBy: orderBy,
      paginationInput: paginationInput,
      mine: mine,
    );
  }

  @override
  Future<DataState<String>> createMaterialProforma(
      {required CreateMaterialProformaParamsEntity params}) {
    return dataSource.createMaterialProforma(
        createMaterialProformaParamsModel:
            CreateMaterialProformaParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<MaterialProformaModel>> getMaterialProformaDetails(
      {required String params}) {
    return dataSource.getMaterialProformaDetails(params: params);
  }

  @override
  Future<DataState<String>> editMaterialProforma(
      {required EditMaterialProformaParamsEntity params}) {
    return dataSource.editMaterialProforma(
        editMaterialProformaParamsModel:
            EditMaterialProformaParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<String>> deleteMaterialProforma(
      {required String materialProformaId}) {
    return dataSource.deleteMaterialProforma(materialProformaId: materialProformaId);
  }
}
