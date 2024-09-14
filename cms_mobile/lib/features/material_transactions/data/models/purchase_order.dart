import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/projects/data/models/project.dart';
import 'package:flutter/material.dart';

class PurchaseOrderModel extends PurchaseOrderEntity {
  const PurchaseOrderModel({
    required super.id,
    required super.approvedById,
    required UserModel? super.approvedBy,
    required super.grandTotal,
    required List<PurchaseOrderItemModel> super.items,
    required super.preparedById,
    required UserModel? super.preparedBy,
    required super.project,
    required super.projectId,
    required super.serialNumber,
    required super.status,
    required super.subTotal,
    required super.updatedAt,
    required super.createdAt,
    required super.vat,
  });

  @override
  List<Object?> get props {
    return [
      id,
      approvedById,
      approvedBy,
      grandTotal,
      items,
      preparedById,
      preparedBy,
      project,
      projectId,
      serialNumber,
      status,
      subTotal,
      vat,
      createdAt,
      updatedAt
    ];
  }

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    // debugPrint('PurchaseOrderModel.fromJson: $json');
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
      grandTotal: json['grandTotal'] != null
          ? (json['grandTotal'] as num).toDouble()
          : 0,
      items: items,
      preparedById: json['preparedById'],
      preparedBy: json['preparedBy'] != null
          ? UserModel.fromJson(json['preparedBy'])
          : null,
      projectId: json['projectId'],
      project: json['project'] != null
          ? ProjectModel.fromJson(json['project'])
          : null,
      serialNumber: json['serialNumber'],
      status: toPurchaseOrderStatus(json['status']),
      subTotal:
          json['subTotal'] != null ? (json['subTotal'] as num).toDouble() : 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      vat: json['vat'] != null ? (json['vat'] as num).toDouble() : 0,
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
      "preparedById": preparedById,
      "preparedBy": preparedBy?.toJson(),
      "projectId": projectId,
      "serialNumber": serialNumber,
      "status": fromPurchaseOrderStatus(status),
      "subTotal": subTotal,
      "vat": vat,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class PurchaseOrderItemModel extends PurchaseOrderItemEntity {
  const PurchaseOrderItemModel({
    required super.id,
    super.materialRequestItemId,
    super.materialRequestItem,
    super.proformaId,
    super.proforma,
    super.purchaseOrderId,
    super.quantity,
    super.remark,
    super.totalPrice,
    super.unitPrice,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItemModel(
      id: json
      ['id'],
      materialRequestItemId: json['materialRequestItemId'],
      materialRequestItem: json['materialRequestItem'] != null
          ? MaterialRequestItemModel.fromJson(json['materialRequestItem'])
          : null,
      proformaId: json['proformaId'],
      proforma: json['proforma'] != null
          ? MaterialProformaModel.fromJson(json['proforma'])
          : null,
      purchaseOrderId: json['purchaseOrderId'],
      quantity:
          json['quantity'] != null ? (json['quantity'] as num).toDouble() : 0,
      unitPrice:
          json['unitPrice'] != null ? (json['unitPrice'] as num).toDouble() : 0,
      totalPrice: json['totalPrice'] != null
          ? (json['totalPrice'] as num).toDouble()
          : 0,
      remark: json['remark'],
      createdAt: json['createdAt']!=null?DateTime.parse(json['createdAt']):null,
      updatedAt:json['updatedAt']!=null? DateTime.parse(json['updatedAt']):null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "materialRequestItemId": materialRequestItemId,
      "materialRequestItem": materialRequestItem,
      "proformaId": proformaId,
      "proforma": proforma,
      "purchaseOrderId": purchaseOrderId,
      "quantity": quantity,
      "remark": remark,
      "totalPrice": totalPrice,
      "unitPrice": unitPrice,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

class PurchaseOrderMaterialModel extends PurchaseOrderMaterialEntity {
  const PurchaseOrderMaterialModel(
      {String? materialRequestItemId,
      MaterialRequestItemModel? materialRequestItem,
      String? proformaId,
      MaterialProformaModel? proforma,
      required double quantity,
      String? remark,
      required double unitPrice,
      required double totalPrice})
      : super(
            materialRequestItemId: materialRequestItemId,
            materialRequestItem: materialRequestItem,
            proforma: proforma,
            proformaId: proformaId,
            quantity: quantity,
            remark: remark,
            unitPrice: unitPrice,
            totalPrice: totalPrice);

  Map<String, dynamic> toJson() {
    return {
      'materialRequestItemId': materialRequestItemId,
      'materialRequestItem': materialRequestItem,
      'proformaId': proformaId,
      'proforma': proforma,
      'remark': remark,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice
    };
  }

  @override
  List<Object?> get props => [
        proformaId,
        proforma,
        materialRequestItemId,
        materialRequestItem,
        quantity,
        unitPrice,
        remark,
        totalPrice
      ];
}

class CreatePurchaseOrderParamsModel
    extends CreatePurchaseOrderParamsEntity<PurchaseOrderMaterialModel> {
  const CreatePurchaseOrderParamsModel({
    required bool isProforma,
    required String projectId,
    required List<PurchaseOrderMaterialModel> purchaseOrderMaterials,
    required String preparedById,
    required double subTotal,
    required double vat,
  }) : super(
            isProforma: isProforma,
            subTotal: subTotal,
            vat: vat,
            preparedById: preparedById,
            projectId: projectId,
            purchaseOrderMaterials: purchaseOrderMaterials);

  @override
  List<Object?> get props => [
        isProforma,
        projectId,
        preparedById,
        purchaseOrderMaterials,
        subTotal,
        vat
      ];

  factory CreatePurchaseOrderParamsModel.fromEntity(
      CreatePurchaseOrderParamsEntity entity) {
    return CreatePurchaseOrderParamsModel(
        isProforma: entity.isProforma,
        projectId: entity.projectId,
        preparedById: entity.preparedById,
        subTotal: entity.subTotal,
        vat: entity.vat,
        purchaseOrderMaterials: entity.purchaseOrderMaterials
            .map((material) => PurchaseOrderMaterialModel(
                  quantity: material.quantity,
                  unitPrice: material.unitPrice,
                  totalPrice: material.totalPrice,
                  materialRequestItemId: material.materialRequestItemId,
                  proformaId: material.proformaId,
                  remark: material.remark,
                ))
            .toList());
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
