import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:equatable/equatable.dart';

class PurchaseOrderLocalState extends Equatable {
  final List<PurchaseOrderMaterialEntity>? purchaseOrderMaterials;

  const PurchaseOrderLocalState({this.purchaseOrderMaterials});

  @override
  List<Object?> get props => [purchaseOrderMaterials];
}
