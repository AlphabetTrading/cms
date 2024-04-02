import 'package:cms_mobile/features/materials/domain/entities/material.dart';
import 'package:equatable/equatable.dart';

class MaterialRequestMaterialEntity extends Equatable {
  final double requestedQuantity;
  final MaterialEntity material;
  final String? remark;
  final String unit;

  const MaterialRequestMaterialEntity(
      {required this.material,
      this.remark,
      required this.unit,
      required this.requestedQuantity});

  @override
  List<Object?> get props => [unit, material, remark, requestedQuantity];
}
