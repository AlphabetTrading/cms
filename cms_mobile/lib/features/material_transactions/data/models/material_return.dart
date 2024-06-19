import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/warehouse/data/models/warehouse.dart';
import 'package:flutter/material.dart';

class MaterialReturnModel extends MaterialReturnEntity {
  const MaterialReturnModel({
    required String id,
    required String serialNumber,
    WarehouseModel? receivingStore,
    List<MaterialReturnItemModel>? items,
    String? returnedById,
    UserModel? returnedBy,
    String? receivedById,
    UserModel? receivedBy,
    MaterialReturnStatus? status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          serialNumber: serialNumber,
          receivingStore: receivingStore,
          items: items,
          returnedById: returnedById,
          returnedBy: returnedBy,
          receivedById: receivedById,
          receivedBy: receivedBy,
          status: status,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory MaterialReturnModel.fromJson(Map<String, dynamic> json) {
    debugPrint(
        "MaterialReturnModel.fromJson: ${toMaterialReturnStatus(json['status'])}");
    return MaterialReturnModel(
      id: json['id'],
      serialNumber: json['serialNumber'],
      receivingStore: json['receivingStore'] != null
          ? WarehouseModel.fromJson(json['receivingStore'])
          : null,
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
      status: toMaterialReturnStatus(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class MaterialReturnItemModel extends MaterialReturnItem {
  const MaterialReturnItemModel({
    required String id,
    String? issueVoucherId,
    UnitOfMeasure? unitOfMeasure,
    double? quantityReturned,
    double? unitCost,
    double? totalCost,
    String? remark,
    String? materialReturnVoucherId,
    String? productVariantId,
  }) : super(
          id: id,
          issueVoucherId: issueVoucherId,
          unitOfMeasure: unitOfMeasure,
          quantityReturned: quantityReturned,
          unitCost: unitCost,
          totalCost: totalCost,
          remark: remark,
          materialReturnVoucherId: materialReturnVoucherId,
          productVariantId: productVariantId,
        );

  factory MaterialReturnItemModel.fromJson(Map<String, dynamic> json) {
    return MaterialReturnItemModel(
      id: json['id'],
      issueVoucherId: json['issueVoucherId'],
      unitOfMeasure: json['unitOfMeasure'],
      quantityReturned: json['quantityReturned'],
      unitCost: json['unitCost'],
      totalCost: json['totalCost'],
      remark: json['remark'],
      materialReturnVoucherId: json['materialReturnVoucherId'],
      productVariantId: json['productVariantId'],
    );
  }

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
    required double quantity,
    String? remark,
    required WarehouseProductModel material,
    required String issueVoucherId,
    required double unitCost,
  }) : super(
          quantity: quantity,
          remark: remark,
          material: material,
          issueVoucherId: issueVoucherId,
          unitCost: unitCost,
        );

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'remark': remark,
    };
  }

  @override
  List<Object?> get props =>
      [remark, quantity, material, issueVoucherId, unitCost];
}

class CreateMaterialReturnParamsModel
    extends CreateMaterialReturnParamsEntity<MaterialReturnMaterialModel> {
  const CreateMaterialReturnParamsModel(
      {required String projectId,
      required List<MaterialReturnMaterialModel> materialReturnMaterials,
      required String returnedById,
      required String receivingStoreId})
      : super(
            returnedById: returnedById,
            projectId: projectId,
            materialReturnMaterials: materialReturnMaterials,
            receivingStoreId: receivingStoreId);

  @override
  List<Object?> get props =>
      [projectId, returnedById, materialReturnMaterials, receivingStoreId];

  factory CreateMaterialReturnParamsModel.fromEntity(
      CreateMaterialReturnParamsEntity entity) {
    return CreateMaterialReturnParamsModel(
        projectId: entity.projectId,
        returnedById: entity.returnedById,
        receivingStoreId: entity.receivingStoreId,
        materialReturnMaterials: entity.materialReturnMaterials
            .map((e) => MaterialReturnMaterialModel(
                quantity: e.quantity,
                remark: e.remark,
                issueVoucherId: e.issueVoucherId,
                material: e.material as WarehouseProductModel,
                unitCost: e.unitCost))
            .toList());
  }
}

class MaterialReturnListWithMeta extends MaterialReturnEntityListWithMeta {
  MaterialReturnListWithMeta({
    required Meta meta,
    required List<MaterialReturnModel> items,
  }) : super(meta: meta, items: items);

  factory MaterialReturnListWithMeta.fromJson(Map<String, dynamic> json) {
    debugPrint("MaterialReturnListWithMeta.fromJson: $json");

    return MaterialReturnListWithMeta(
      meta: Meta.fromJson(json['meta']),
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