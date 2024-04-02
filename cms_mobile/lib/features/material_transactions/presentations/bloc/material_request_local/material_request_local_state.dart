import 'package:cms_mobile/features/material_transactions/domain/entities/material_request_material.dart';
import 'package:equatable/equatable.dart';

class MaterialRequestLocalState extends Equatable{
  final List<MaterialRequestMaterialEntity> ? materialRequestMaterials;


  const MaterialRequestLocalState({this.materialRequestMaterials});

  @override
  List<Object?> get props => [materialRequestMaterials];
}
