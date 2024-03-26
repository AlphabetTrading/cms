import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/materials/data/data_sources/remote_data_source.dart';
import 'package:cms_mobile/features/materials/data/models/material.dart';
import 'package:cms_mobile/features/materials/domain/repository/material_repository.dart';

class MaterialRepositoryImpl extends MaterialRepository{
  final MaterialsDataSource dataSource;
  MaterialRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<List<MaterialModel>>> getMaterials() {
    return dataSource.fetchMaterials();
  }

}