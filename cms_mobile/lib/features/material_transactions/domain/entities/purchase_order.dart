import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

class PurchaseOrderEntity extends Equatable {
  final String id;
  final String? approvedById;
  final double? grandTotal;
  final List<PurchaseOrderItemEntity> items;
  final String? materialRequestId;
  final String? preparedById;
  final String? projectId;
  final String? serialNumber;
  final PurchaseOrderStatus? status;
  final double? subTotal;
  final String? supplierName;
  final double? vat;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PurchaseOrderEntity({
    required this.approvedById,
    required this.createdAt,
    required this.grandTotal,
    required this.id,
    required this.items,
    required this.materialRequestId,
    required this.preparedById,
    required this.projectId,
    required this.serialNumber,
    required this.status,
    required this.subTotal,
    required this.supplierName,
    required this.updatedAt,
    required this.vat,
  });

  @override
  List<Object?> get props => [
        approvedById,
        createdAt,
        grandTotal,
        id,
        items,
        materialRequestId,
        preparedById,
        projectId,
        serialNumber,
        status,
        subTotal,
        supplierName,
        updatedAt,
        vat,
      ];
}

class PurchaseOrderItemEntity extends Equatable {
  final String id;
  final ProductVariantEntity? productVariant;
  final String? productVariantId;
  final String? purchaseOrderId;
  final double? quantityRequested;
  final String? remark;
  final double? totalPrice;
  final double? unitPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PurchaseOrderItemEntity({
    required this.id,
    this.productVariant,
    this.productVariantId,
    this.purchaseOrderId,
    this.quantityRequested,
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
        productVariant,
        productVariantId,
        purchaseOrderId,
        quantityRequested,
        remark,
        totalPrice,
        unitPrice,
        updatedAt,
      ];

  PurchaseOrderItemEntity.fromJson(Map<String, dynamic> json)
      : createdAt = json['createdAt'],
        id = json['id'],
        productVariant = json['productVariant'],
        productVariantId = json['productVariantId'],
        purchaseOrderId = json['purchaseOrderId'],
        quantityRequested = json['quantityRequested'],
        remark = json['remark'],
        totalPrice = json['totalPrice'],
        unitPrice = json['unitPrice'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['productVariant'] = productVariant;
    data['productVariantId'] = productVariantId;
    data['purchaseOrderId'] = purchaseOrderId;
    data['quantityRequested'] = quantityRequested;
    data['remark'] = remark;
    data['totalPrice'] = totalPrice;
    data['unitPrice'] = unitPrice;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class CreatePurchaseOrderParamsEntity<T extends PurchaseOrderEntity>
    extends Equatable {
  final String projectId;
  final String preparedById;
  final String warehouseStoreId;
  final List<T> purchaseOrderMaterials;

  const CreatePurchaseOrderParamsEntity({
    required this.projectId,
    required this.preparedById,
    required this.purchaseOrderMaterials,
    required this.warehouseStoreId,
  });

  @override
  List<Object?> get props => [preparedById, projectId, purchaseOrderMaterials];
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
  final Meta meta;

  PurchaseOrderEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}

class PurchaseOrderMaterialEntity extends Equatable {
  final double quantity;
  final String? remark;
  final WarehouseProductEntity? material;
  final UseType useType;
  final SubStructureUseDescription? subStructureDescription;
  final SuperStructureUseDescription? superStructureDescription;

  const PurchaseOrderMaterialEntity({
    this.remark,
    this.material,
    required this.quantity,
    this.subStructureDescription,
    this.superStructureDescription,
    required this.useType,
  });

  @override
  List<Object?> get props => [
        remark,
        quantity,
        material,
        useType,
        subStructureDescription,
        superStructureDescription,
      ];
}
