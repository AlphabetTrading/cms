import 'package:cms_mobile/core/entities/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';
import 'package:equatable/equatable.dart';

class PurchaseOrderEntity extends Equatable {
  final String id;
  final String? approvedById;
  final UserEntity? approvedBy;
  final double? grandTotal;
  final List<PurchaseOrderItemEntity> items;
  final String? preparedById;
  final UserEntity? preparedBy;
  final ProjectEntity? project;
  final String? projectId;
  final String? serialNumber;
  final PurchaseOrderStatus? status;
  final double? subTotal;
  final double? vat;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PurchaseOrderEntity({
    required this.approvedById,
    required this.approvedBy,
    required this.createdAt,
    required this.grandTotal,
    required this.id,
    required this.items,
    required this.preparedById,
    required this.preparedBy,
    required this.project,
    required this.projectId,
    required this.serialNumber,
    required this.status,
    required this.subTotal,
    required this.updatedAt,
    required this.vat,
  });

  @override
  List<Object?> get props => [
        approvedById,
        approvedBy,
        createdAt,
        grandTotal,
        id,
        items,
        preparedById,
        preparedBy,
        project,
        projectId,
        serialNumber,
        status,
        subTotal,
        updatedAt,
        vat,
      ];
}

class PurchaseOrderItemEntity extends Equatable {
  final String id;
  final String? materialRequestItemId;
  final MaterialRequestItem? materialRequestItem;
  final String? proformaId;
  final MaterialProformaEntity? proforma;
  final String? purchaseOrderId;
  final double? quantity;
  final String? remark;
  final double? totalPrice;
  final double? unitPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PurchaseOrderItemEntity({
    required this.id,
    this.materialRequestItemId,
    this.materialRequestItem,
    this.proformaId,
    this.proforma,
    this.purchaseOrderId,
    this.quantity,
    this.remark,
    this.totalPrice,
    this.unitPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        createdAt,
        id,
        materialRequestItemId,
        materialRequestItem,
        proformaId,
        proforma,
        purchaseOrderId,
        quantity,
        remark,
        totalPrice,
        unitPrice,
        updatedAt,
      ];

  PurchaseOrderItemEntity.fromJson(Map<String, dynamic> json)
      : createdAt = json['createdAt'],
        id = json['id'],
        materialRequestItemId = json['materialRequestItemId'],
        materialRequestItem = json['materialRequestItem'],
        proformaId = json['proformaId'],
        proforma = json['proforma'],
        purchaseOrderId = json['purchaseOrderId'],
        quantity = json['quantity'],
        remark = json['remark'],
        totalPrice = json['totalPrice'],
        unitPrice = json['unitPrice'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['materialRequestItemId'] = materialRequestItemId;
    data['materialRequestItem'] = materialRequestItem;
    data['proformaId'] = proformaId;
    data['proforma'] = proforma;
    data['purchaseOrderId'] = purchaseOrderId;
    data['quantity'] = quantity;
    data['remark'] = remark;
    data['totalPrice'] = totalPrice;
    data['unitPrice'] = unitPrice;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class CreatePurchaseOrderParamsEntity<T extends PurchaseOrderMaterialEntity>
    extends Equatable {
  final bool isProforma;
  final String projectId;
  final String preparedById;
  final List<T> purchaseOrderMaterials;

  const CreatePurchaseOrderParamsEntity({
    required this.isProforma,
    required this.projectId,
    required this.preparedById,
    required this.purchaseOrderMaterials,
  });

  @override
  List<Object?> get props =>
      [isProforma, projectId, purchaseOrderMaterials];
}

class EditPurchaseOrderParamsEntity<T extends PurchaseOrderEntity>
    extends Equatable {
  final String updatePurchaseOrderId;
  final String warehouseStoreId;
  final String approved;
  final String approvedById;
  final List<T> purchaseOrderMaterials;

  const EditPurchaseOrderParamsEntity(
      {required this.updatePurchaseOrderId,
      required this.approved,
      required this.approvedById,
      required this.purchaseOrderMaterials,
      required this.warehouseStoreId});

  @override
  List<Object?> get props => [
        updatePurchaseOrderId,
        warehouseStoreId,
        approved,
        approvedById,
        purchaseOrderMaterials
      ];
}

class PurchaseOrderEntityListWithMeta {
  final List<PurchaseOrderEntity> items;
  final MetaEntity meta;

  PurchaseOrderEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}

class PurchaseOrderMaterialEntity extends Equatable {
  final bool? isProforma;
  final String? materialRequestItemId;
  final MaterialRequestItem? materialRequestItem;
  final String? proformaId;
  final MaterialProformaEntity? proforma;
  final double quantity;
  final String? remark;
  final double unitPrice;
  final double totalPrice;

  const PurchaseOrderMaterialEntity(
      {this.remark,
      this.isProforma,
      this.materialRequestItemId,
      this.materialRequestItem,
      this.proformaId,
      this.proforma,
      required this.unitPrice,
      required this.totalPrice,
      required this.quantity});

  @override
  List<Object?> get props => [
        remark,
        quantity,
        isProforma,
        materialRequestItemId,
        materialRequestItem,
        proformaId,
        proforma,
        unitPrice,
        totalPrice,
      ];
}
