import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:flutter/material.dart';

class PurchaseOrderModel extends PurchaseOrderEntity {
  const PurchaseOrderModel({
    required super.id,
    required super.approvedById,
    required UserModel? super.approvedBy,
    required super.grandTotal,
    required List<PurchaseOrderItemModel> super.items,
    required super.materialRequestId,
    required super.preparedById,
    required UserModel? super.preparedBy,
    required super.projectId,
    required super.serialNumber,
    required super.status,
    required super.subTotal,
    required super.supplierName,
    required super.updatedAt,
    required super.createdAt,
    required double super.vat,
  });

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
      approvedBy: json['approvedBy'] != null
          ? UserModel.fromJson(json['approvedBy'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      grandTotal: json['grandTotal'],
      items: items,
      materialRequestId: json['materialRequestId'],
      preparedById: json['preparedById'],
      preparedBy: json['preparedBy'] != null
          ? UserModel.fromJson(json['preparedBy'])
          : null,
      projectId: json['projectId'],
      serialNumber: json['serialNumber'],
      status: toPurchaseOrderStatus(json['status']),
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
      "approvedBy": approvedBy?.toJson(),
      "grandTotal": grandTotal,
      "items": items,
      "materialRequestId": materialRequestId,
      "preparedById": preparedById,
      "preparedBy": preparedBy?.toJson(),
      "projectId": projectId,
      "serialNumber": serialNumber,
      "status": fromPurchaseOrderStatus(status),
      "subTotal": subTotal,
      "supplierName": supplierName,
      "vat": vat,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class PurchaseOrderItemModel extends PurchaseOrderItemEntity {
  //            __typename: PurchaseOrderItem,
//            createdAt: 2024-08-14T12:05:31.315Z,
//            id: 84d47293-e5a0-4372-9028-477e2a99b504,
//            materialRequestItemId: 540a5fa4-db98-4060-8178-988a4de827c7,
//            proformaId: null,
//            purchaseOrderId: c144367d-2eb9-46c4-88b1-2cfbbf20a25e,
//            quantity: 10,
//            remark: null,
//            totalPrice: 150,
//            unitPrice: 15,
//            updatedAt: 2024-08-14T12:05:31.315Z
  //          }
  const PurchaseOrderItemModel({
    required super.id,
    ProductVariantModel? super.productVariant,
    super.productVariantId,
    super.purchaseOrderId,
    super.quantityRequested,
    super.remark,
    super.totalPrice,
    super.unitPrice,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) {
    final productVariant = json['productVariant'] != null
        ? ProductVariantModel.fromJson(json['productVariant'])
        : null;

    return PurchaseOrderItemModel(
      id: json['id'],
      productVariant: productVariant,
      productVariantId: json['productVariantId'],
      purchaseOrderId: json['purchaseOrderId'],
      quantityRequested: json['quantityRequested'],
      remark: json['remark'],
      totalPrice: json['totalPrice'],
      unitPrice: json['unitPrice'],
      createdAt: DateTime.parse(json['createdAt']),
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
    required MetaModel super.meta,
    required List<PurchaseOrderModel> super.items,
  });

  factory PurchaseOrdersListWithMeta.fromJson(Map<String, dynamic> json) {
    return PurchaseOrdersListWithMeta(
      meta: MetaModel.fromJson(json['meta']),
      items: json['items']
          .map<PurchaseOrderModel>((item) => PurchaseOrderModel.fromJson(item))
          .toList(),
    );
  }
}

// from enum

enum PurchaseOrderStatus { completed, pending, declined }

PurchaseOrderStatus toPurchaseOrderStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return PurchaseOrderStatus.completed;
    case 'PENDING':
      return PurchaseOrderStatus.pending;
    case 'DECLINED':
      return PurchaseOrderStatus.declined;
    default:
      throw Exception('Invalid PurchaseOrderStatus');
  }
}

String fromPurchaseOrderStatus(PurchaseOrderStatus? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case PurchaseOrderStatus.completed:
      return 'COMPLETED';
    case PurchaseOrderStatus.pending:
      return 'PENDING';
    case PurchaseOrderStatus.declined:
      return 'DECLINED';
  }
}
