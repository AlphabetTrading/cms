import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:flutter/material.dart';

class PurchaseOrderModel extends PurchaseOrderEntity {
  const PurchaseOrderModel({
    required String id,
    required String? approvedById,
    required double? grandTotal,
    required List<PurchaseOrderItemModel> items,
    required String? materialRequestId,
    required String? preparedById,
    required String? projectId,
    required String? serialNumber,
    required String? status,
    required double? subTotal,
    required String? supplierName,
    required DateTime updatedAt,
    required DateTime createdAt,
    required double vat,
  }) : super(
          approvedById: approvedById,
          createdAt: createdAt,
          grandTotal: grandTotal,
          id: id,
          items: items,
          materialRequestId: materialRequestId,
          preparedById: preparedById,
          projectId: projectId,
          serialNumber: serialNumber,
          status: status,
          subTotal: subTotal,
          supplierName: supplierName,
          updatedAt: updatedAt,
          vat: vat,
        );

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    debugPrint('PurchaseOrderModel.fromJson: $json');
    final items = json['items'] != null
        ? json['items']
            .map<PurchaseOrderItemModel>(
                (item) => PurchaseOrderItemModel.fromJson(item))
            .toList()
        : <PurchaseOrderItemModel>[]; // if items is null, return an empty list
    return PurchaseOrderModel(
      id: json['id'],
      approvedById: json['approvedById'],
      createdAt: DateTime.parse(json['createdAt']),
      grandTotal: json['grandTotal'],
      items: items,
      materialRequestId: json['materialRequestId'],
      preparedById: json['preparedById'],
      projectId: json['projectId'],
      serialNumber: json['serialNumber'],
      status: json['status'],
      subTotal: json['subTotal'],
      supplierName: json['supplierName'],
      updatedAt: DateTime.parse(json['updatedAt']),
      vat: json['vat'],
    );
  }

  Map<String, dynamic> toJson() {
    final items = this.items.map((e) => e.toJson()).toList();

    return {
      "id": id,
      "approvedById": approvedById,
      "createdAt": createdAt.toIso8601String(),
      "grandTotal": grandTotal,
      "items": items,
      "materialRequestId": materialRequestId,
      "preparedById": preparedById,
      "projectId": projectId,
      "serialNumber": serialNumber,
      "status": status,
      "subTotal": subTotal,
      "supplierName": supplierName,
      "updatedAt": updatedAt.toIso8601String(),
      "vat": vat,
    };
  }
}

class PurchaseOrderItemModel extends PurchaseOrderItemEntity {
  const PurchaseOrderItemModel({
    required String id,
    ProductVariantModel? productVariant,
    String? productVariantId,
    String? purchaseOrderId,
    double? quantityRequested,
    String? remark,
    double? totalPrice,
    double? unitPrice,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          createdAt: createdAt,
          id: id,
          productVariant: productVariant,
          productVariantId: productVariantId,
          purchaseOrderId: purchaseOrderId,
          quantityRequested: quantityRequested,
          remark: remark,
          totalPrice: totalPrice,
          unitPrice: unitPrice,
          updatedAt: updatedAt,
        );

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) {
    final productVariant = ProductVariantModel.fromJson(json['productVariant']);

    return PurchaseOrderItemModel(
      createdAt: DateTime.parse(json['createdAt']),
      id: json['id'],
      productVariant: productVariant,
      productVariantId: json['productVariantId'],
      purchaseOrderId: json['purchaseOrderId'],
      quantityRequested: json['quantityRequested'],
      remark: json['remark'],
      totalPrice: json['totalPrice'],
      unitPrice: json['unitPrice'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productVariant": productVariant,
      "productVariantId": productVariantId,
      "purchaseOrderId": purchaseOrderId,
      "quantityRequested": quantityRequested,
      "remark": remark,
      "totalPrice": totalPrice,
      "unitPrice": unitPrice,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class CreatePurchaseOrderParamsModel
    extends CreatePurchaseOrderParamsEntity<PurchaseOrderModel> {
  const CreatePurchaseOrderParamsModel({
    required String projectId,
    required List<PurchaseOrderModel> purchaseOrderMaterials,
    required String preparedById,
    required String warehouseStoreId,
  }) : super(
            warehouseStoreId: warehouseStoreId,
            preparedById: preparedById,
            projectId: projectId,
            purchaseOrderMaterials: purchaseOrderMaterials);

  Map<String, dynamic> toJson() {
    return {
      "preparedById": preparedById,
      "projectId": projectId,
      "warehouseStoreId": warehouseStoreId,
      "items": purchaseOrderMaterials.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object?> get props => [projectId, preparedById, purchaseOrderMaterials];

  factory CreatePurchaseOrderParamsModel.fromEntity(
      CreatePurchaseOrderParamsEntity entity) {
    return CreatePurchaseOrderParamsModel(
      projectId: entity.projectId,
      preparedById: entity.preparedById,
      warehouseStoreId: entity.warehouseStoreId,
      purchaseOrderMaterials: const [],
    );
  }
}

class EditPurchaseOrderParamsModel
    extends EditPurchaseOrderParamsEntity<PurchaseOrderModel> {
  const EditPurchaseOrderParamsModel(
      {required String approved,
      required List<PurchaseOrderModel> purchaseOrderMaterials,
      required String approvedById,
      required String warehouseStoreId,
      required String updatePurchaseOrderId})
      : super(
            approved: approved,
            warehouseStoreId: warehouseStoreId,
            approvedById: approvedById,
            purchaseOrderMaterials: purchaseOrderMaterials,
            updatePurchaseOrderId: updatePurchaseOrderId);

  Map<String, dynamic> toJson() {
    return {
      "warehouseStoreId": warehouseStoreId,
      "approved": approved,
      "approvedById": approvedById,
      "items": purchaseOrderMaterials.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        updatePurchaseOrderId,
        warehouseStoreId,
        approved,
        approvedById,
        purchaseOrderMaterials
      ];

  factory EditPurchaseOrderParamsModel.fromEntity(
      EditPurchaseOrderParamsEntity entity) {
    return EditPurchaseOrderParamsModel(
      updatePurchaseOrderId: entity.updatePurchaseOrderId,
      approved: entity.approved,
      warehouseStoreId: entity.warehouseStoreId,
      approvedById: entity.approvedById,
      purchaseOrderMaterials: [],
    );
  }
}

class FilterPurchaseOrderInput {
  final StringFilter? createdAt;
  final StringFilter? approvedBy;
  final StringFilter? preparedBy;
  final StringFilter? serialNumber;
  final List<String>? status;

  FilterPurchaseOrderInput(
      {this.createdAt,
      this.approvedBy,
      this.preparedBy,
      this.serialNumber,
      this.status});

  Map<String, dynamic> toJson() {
    // include the property if it is only not null
    return {
      if (approvedBy != null)
        'approvedBy': {
          'fullName': approvedBy!.toJson(),
        },
      if (preparedBy != null)
        'preparedBy': {
          'fullName': preparedBy!.toJson(),
        },
      if (serialNumber != null) 'serialNumber': serialNumber!.toJson(),
      if (status != null) 'status': status,
    };
  }
}

class OrderByPurchaseOrderInput {
  final String? createdAt;

  OrderByPurchaseOrderInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}

class PurchaseOrdersListWithMeta extends PurchaseOrderEntityListWithMeta {
  PurchaseOrdersListWithMeta({
    required Meta meta,
    required List<PurchaseOrderModel> items,
  }) : super(meta: meta, items: items);

  factory PurchaseOrdersListWithMeta.fromJson(Map<String, dynamic> json) {
    return PurchaseOrdersListWithMeta(
      meta: Meta.fromJson(json['meta']),
      items: json['items']
          .map<PurchaseOrderModel>((item) => PurchaseOrderModel.fromJson(item))
          .toList(),
    );
  }
}


// from enum 