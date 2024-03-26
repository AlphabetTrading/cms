import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/materials/data/models/material.dart';

abstract class MaterialRepository{
  Future<DataState<List<MaterialModel>>> getMaterials();
}