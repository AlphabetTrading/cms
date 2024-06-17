import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:equatable/equatable.dart';

class MaterialReceiveLocalState extends Equatable {
  final List<MaterialReceiveMaterialEntity>? materialReceiveMaterials;

  const MaterialReceiveLocalState({this.materialReceiveMaterials});

  @override
  List<Object?> get props => [materialReceiveMaterials];
}
