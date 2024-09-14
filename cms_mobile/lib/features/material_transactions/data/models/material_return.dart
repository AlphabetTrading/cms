import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/warehouse/data/models/warehouse.dart';
import 'package:flutter/material.dart';

class MaterialReturnModel extends MaterialReturnEntity {
  const MaterialReturnModel({
    required String super.id,
    required String super.serialNumber,
    WarehouseModel? super.receivingWarehouseStore,
    List<MaterialReturnItemModel>? super.items,
    super.returnedById,
    UserModel? super.returnedBy,
    super.receivedById,
    UserModel? super.receivedBy,
    super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MaterialReturnModel.fromJson(Map<String, dynamic> json) {
    debugPrint(
        "MaterialReturnModel.fromJson: ${toMaterialReturnStatus(json['status'])}");
    return MaterialReturnModel(
      id: json['id'],
      serialNumber: json['serialNumber'],
      items: json['items']
          .map<MaterialReturnItemModel>(
              (item) => MaterialReturnItemModel.fromJson(item))
          .toList(),
      returnedById: json['returnedById'],
      returnedBy: json['returnedBy'] != null
          ? UserModel.fromJson(json['returnedBy'])
          : null,
      receivedById: json['receivedById'],
      receivedBy: json['receivedBy'] != null
          ? UserModel.fromJson(json['receivedBy'])
          : null,
      receivingWarehouseStore:  json['receivingWarehouseStore']!=null?WarehouseModel.fromJson(json['receivingWarehouseStore']):null,
      status: toMaterialReturnStatus(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class MaterialReturnItemModel extends MaterialReturnItem {
  const MaterialReturnItemModel({
    required super.id,
    super.issueVoucherId,
    super.unitOfMeasure,
    super.quantityReturned,
    super.unitCost,
    super.totalCost,
    super.remark,
    super.materialReturnVoucherId,
    super.productVariantId,
    super.productVariant,
    super.issueVoucher,
  });

  factory MaterialReturnItemModel.fromJson(Map<String, dynamic> json) {
    return MaterialReturnItemModel(
      id: json['id'],
      issueVoucherId: json['issueVoucherId'],
      unitOfMeasure: json['unitOfMeasure'],
      quantityReturned: json['quantity']!=null?(json['quantity'] as num).toDouble():null,
      unitCost: json['unitCost']!=null?(json['unitCost'] as num).toDouble():null,
      totalCost: json['totalCost'] != null?(json['totalCost'] as num).toDouble():null,
      remark: json['remark'],
      materialReturnVoucherId: json['materialReturnVoucherId'],
      productVariantId: json['productVariantId'],
      productVariant:json['productVariant']!=null?ProductVariantModel.fromJson(json['productVariant']):null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issueVoucherId': issueVoucherId,
      'issueVoucher': null,
      'unitOfMeasure': unitOfMeasure,
      'quantityReturned': quantityReturned,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'remark': remark,
      'materialReturnVoucherId': materialReturnVoucherId,
      'materialReturnVoucher': null,
      'productVariantId': productVariantId,
    };
  }
}

class MaterialReturnMaterialModel extends MaterialReturnMaterialEntity {
  const MaterialReturnMaterialModel({
    required super.quantity,
    super.remark,
    required IssueVoucherMaterialModel super.material,
    required super.issueVoucherId,
  });

  Map<String, dynamic> toJson() {
    return {
      "issueVoucherId": issueVoucherId,
      "productVariantId": material?.productVariant?.id,
      "quantity": quantity,
      "remark": remark,
      "totalCost": material?.unitCost ?? 0.0 * quantity,
      "unitCost": material?.unitCost ?? 0.0
    };
  }

  @override
  List<Object?> get props => [remark, quantity, material, issueVoucherId];
}

class CreateMaterialReturnParamsModel
    extends CreateMaterialReturnParamsEntity<MaterialReturnMaterialModel> {
  const CreateMaterialReturnParamsModel(
      {required super.projectId,
      required super.materialReturnMaterials,
      required super.returnedById,
      required super.receivingWarehouseStoreId});

  @override
  List<Object?> get props =>
      [projectId, returnedById, materialReturnMaterials, receivingWarehouseStoreId];

  factory CreateMaterialReturnParamsModel.fromEntity(
      CreateMaterialReturnParamsEntity entity) {
    return CreateMaterialReturnParamsModel(
        projectId: entity.projectId,
        returnedById: entity.returnedById,
        receivingWarehouseStoreId: entity.receivingWarehouseStoreId,
        materialReturnMaterials: entity.materialReturnMaterials
            .map((e) => MaterialReturnMaterialModel(
                  quantity: e.quantity,
                  remark: e.remark,
                  issueVoucherId: e.issueVoucherId,
                  material: e.material as IssueVoucherMaterialModel,
                ))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "projectId": projectId,
      "receivingWarehouseStoreId": receivingWarehouseStoreId,
      "returnedById": returnedById,
      "items": materialReturnMaterials.map((e) => e.toJson()).toList()
    };
  }
}

class MaterialReturnListWithMeta extends MaterialReturnEntityListWithMeta {
  MaterialReturnListWithMeta({
    required MetaModel super.meta,
    required List<MaterialReturnModel> super.items,
  });

  factory MaterialReturnListWithMeta.fromJson(Map<String, dynamic> json) {
    debugPrint("MaterialReturnListWithMeta.fromJson: $json");

    return MaterialReturnListWithMeta(
      meta: MetaModel.fromJson(json['meta']),
      items: json['items']
          .map<MaterialReturnModel>(
              (item) => MaterialReturnModel.fromJson(item))
          .toList(),
    );
  }
}

MaterialReturnStatus toMaterialReturnStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return MaterialReturnStatus.completed;
    case 'PENDING':
      return MaterialReturnStatus.pending;
    case 'DECLINED':
      return MaterialReturnStatus.declined;
    default:
      throw Exception('Invalid MaterialReturnStatus');
  }
}

String fromMaterialReturnStatus(MaterialReturnStatus? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case MaterialReturnStatus.completed:
      return 'COMPLETED';
    case MaterialReturnStatus.pending:
      return 'PENDING';
    case MaterialReturnStatus.declined:
      return 'DECLINED';
  }
}
