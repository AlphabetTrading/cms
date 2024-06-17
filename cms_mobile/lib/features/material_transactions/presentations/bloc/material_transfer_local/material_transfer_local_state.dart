

import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:equatable/equatable.dart';

class MaterialTransferLocalState extends Equatable{
  final List<MaterialTransferEntity> ? materialTransferMaterials;


  const MaterialTransferLocalState({this.materialTransferMaterials});

  @override
  List<Object?> get props => [materialTransferMaterials];
}

