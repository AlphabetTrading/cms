import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';

abstract class MaterialReturnRepository{
  Future<DataState<String>> createMaterialReturn({
    required CreateMaterialReturnParamsEntity params
  });

}