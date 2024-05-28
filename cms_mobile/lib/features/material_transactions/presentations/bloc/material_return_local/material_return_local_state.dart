

import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:equatable/equatable.dart';

class MaterialReturnLocalState extends Equatable{
  final List<MaterialReturnMaterialEntity> ? materialReturnMaterials;


  const MaterialReturnLocalState({this.materialReturnMaterials});

  @override
  List<Object?> get props => [materialReturnMaterials];
}

