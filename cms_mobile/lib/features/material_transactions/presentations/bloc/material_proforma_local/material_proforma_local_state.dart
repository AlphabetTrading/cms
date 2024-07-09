import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:equatable/equatable.dart';

class MaterialProformaLocalState extends Equatable {
  final List<MaterialProformaMaterialEntity>? materialProformaMaterials;

  const MaterialProformaLocalState({this.materialProformaMaterials});

  @override
  List<Object?> get props => [materialProformaMaterials];
}
