import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/warehouse/data/models/warehouse.dart';

import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:flutter/material.dart';

class MaterialReceiveModel extends MaterialReceiveEntity {
  const MaterialReceiveModel({
    required String? id,
    required String? serialNumber,
    required String? status,
    required String? approvedById,
    UserModel? approvedBy,
    required String? projectDetails,
    required String? requisitionNumber,
    List<ReceiveVoucherMaterialModel>? items,
    required String? preparedById,
    UserModel? preparedBy,
    required String? receivedById,
    UserModel? receivedBy,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    WarehouseModel? warehouse,
  }) : super(
            id: id,
            serialNumber: serialNumber,
            status: status,
            approvedById: approvedById,
            approvedBy: approvedBy,
            projectDetails: projectDetails,
            requisitionNumber: requisitionNumber,
            items: items,
            preparedById: preparedById,
            preparedBy: preparedBy,
            receivedById: receivedById,
            receivedBy: receivedBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            warehouse: warehouse);

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialReceiveModel.fromJson(Map<String, dynamic> json) {
    debugPrint("MaterialReceiveModel.fromJson: $json");

    return MaterialReceiveModel(
        id: json['id'],
        serialNumber: json['serialNumber'],
        projectDetails: json['projectDetails'],
        requisitionNumber: json['requisitionNumber'],
        items: json['items'].map<ReceiveVoucherMaterialModel>((item) {
          return ReceiveVoucherMaterialModel.fromJson(item);
        }).toList(),
        preparedById: json['preparedById'],
        preparedBy: json['preparedBy'] != null
            ? UserModel.fromJson(json['preparedBy'])
            : null,
        approvedById: json['approvedById'],
        approvedBy: json['approvedBy'] != null
            ? UserModel.fromJson(json['approvedBy'])
            : null,
        status: json['status'],
        receivedById: json['receivedById'],
        receivedBy: json['receivedBy'] != null
            ? UserModel.fromJson(json['receivedBy'])
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        warehouse: json['warehouseStore'] != null
            ? WarehouseModel.fromJson(json['warehouseStore'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serialNumber': serialNumber,
      'status': status,
      'approvedById': approvedById,
      'approvedBy': approvedBy,
      'projectDetails': projectDetails,
      'requisitionNumber': requisitionNumber,
      'items': items,
      'preparedById': preparedById,
      'preparedBy': preparedBy,
      'receivedById': receivedById,
      'receivedBy': receivedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ReceiveVoucherMaterialModel extends ReceiveVoucherMaterialEntity {
  const ReceiveVoucherMaterialModel({
    required String? id,
    required ProductVariantModel? productVariant,
    required double? quantity,
    required String? remark,
    required double? totalCost,
    required double? unitCost,
    required SubStructureUseDescription? subStructureDescription,
    required SuperStructureUseDescription? superStructureDescription,
    required UseType? useType,
    required String? materialReceiveVoucherId,
  }) : super(
            id: id,
            productVariant: productVariant,
            quantity: quantity,
            remark: remark,
            totalCost: totalCost,
            unitCost: unitCost,
            subStructureDescription: subStructureDescription,
            superStructureDescription: superStructureDescription,
            useType: useType,
            materialReceiveVoucherId: materialReceiveVoucherId);

  factory ReceiveVoucherMaterialModel.fromJson(Map<String, dynamic> json) {
    try {
      return ReceiveVoucherMaterialModel(
          id: json['id'],
          productVariant: ProductVariantModel.fromJson(json['productVariant']),
          quantity: json['quantity'],
          remark: json['remark'],
          totalCost: json['totalCost'],
          unitCost: json['unitCost'],
          subStructureDescription: subStructureUseDescriptionFromString(
              json['subStructureDescription']),
          superStructureDescription: superStructureUseDescriptionFromString(
              json['superStructureDescription']),
          useType: useTypeFromString(json['useType']),
          materialReceiveVoucherId: json['materialReceiveVoucherId']);
    } catch (e) {
      print('Error in Receive Voucer Material Model ${e}');
    }
    return ReceiveVoucherMaterialModel(
        id: json['id'],
        productVariant: ProductVariantModel.fromJson(json['productVariant']),
        quantity: json['quantity'],
        remark: json['remark'],
        totalCost: json['totalCost'],
        unitCost: json['unitCost'],
        subStructureDescription: subStructureUseDescriptionFromString(
            json['subStructureDescription']),
        superStructureDescription: superStructureUseDescriptionFromString(
            json['superStructureDescription']),
        useType: useTypeFromString(json['useType']),
        materialReceiveVoucherId: json['materialReceiveVoucherId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productVariant': productVariant,
      'quantity': quantity,
      'remark': remark,
      'totalCost': totalCost,
      'unitCost': unitCost,
      'subStructureDescription': subStructureDescription,
      'superStructureDescription': superStructureDescription,
      'useType': useType,
      'materialReceiveVoucherId': materialReceiveVoucherId
    };
  }
}

class MaterialReceiveListWithMeta extends MaterialReceiveEntityListWithMeta {
  MaterialReceiveListWithMeta({
    required Meta meta,
    required List<MaterialReceiveModel> items,
  }) : super(meta: meta, items: items);

  factory MaterialReceiveListWithMeta.fromJson(Map<String, dynamic> json) {
    return MaterialReceiveListWithMeta(
      meta: Meta.fromJson(json['meta']),
      items: json['items']
          .map<MaterialReceiveModel>(
              (item) => MaterialReceiveModel.fromJson(item))
          .toList(),
    );
  }
}

class MaterialReceiveMaterialModel extends MaterialReceiveMaterialEntity {
  const MaterialReceiveMaterialModel(
      {required double quantity,
      String? remark,
      WarehouseProductModel? material,
      required UseType useType,
      SubStructureUseDescription? subStructureDescription,
      SuperStructureUseDescription? superStructureDescription})
      : super(
            quantity: quantity,
            material: material,
            remark: remark,
            useType: useType,
            subStructureDescription: subStructureDescription,
            superStructureDescription: superStructureDescription
            // unit: unit
            );

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'remark': remark,
      "productVariantId": material!.productVariant.id,
      "useType": useType.name,
      "unitCost": material!.currentPrice,
      "totalCost": material!.currentPrice * quantity,
      "subStructureDescription":
          subStructureDescription != SubStructureUseDescription.DEFAULT_VALUE
              ? subStructureDescription!.name
              : null,
      "superStructureDescription": superStructureDescription !=
              SuperStructureUseDescription.DEFAULT_VALUE
          ? superStructureDescription!.name
          : null,
    };
  }

  @override
  List<Object?> get props => [
        remark,
        quantity,
        material,
        useType,
        subStructureDescription,
        superStructureDescription
      ];
}

class CreateMaterialReceiveParamsModel
    extends CreateMaterialReceiveParamsEntity<MaterialReceiveMaterialModel> {
  const CreateMaterialReceiveParamsModel({
    required String projectId,
    required List<MaterialReceiveMaterialModel> materialReceiveMaterials,
    required String preparedById,
    required String warehouseStoreId,
  }) : super(
            warehouseStoreId: warehouseStoreId,
            preparedById: preparedById,
            projectId: projectId,
            materialReceiveMaterials: materialReceiveMaterials);

  Map<String, dynamic> toJson() {
    return {
      "preparedById": preparedById,
      "projectId": projectId,
      "warehouseStoreId": warehouseStoreId,
      "items": materialReceiveMaterials.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object?> get props =>
      [projectId, preparedById, materialReceiveMaterials];

  factory CreateMaterialReceiveParamsModel.fromEntity(
      CreateMaterialReceiveParamsEntity entity) {
    return CreateMaterialReceiveParamsModel(
        projectId: entity.projectId,
        preparedById: entity.preparedById,
        warehouseStoreId: entity.warehouseStoreId,
        materialReceiveMaterials: entity.materialReceiveMaterials
            .map((e) => MaterialReceiveMaterialModel(
                quantity: e.quantity,
                material: e.material as WarehouseProductModel,
                remark: e.remark,
                useType: e.useType,
                subStructureDescription: e.subStructureDescription,
                superStructureDescription: e.superStructureDescription))
            .toList());
  }
}

class EditMaterialReceiveParamsModel
    extends EditMaterialReceiveParamsEntity<MaterialReceiveMaterialModel> {
  const EditMaterialReceiveParamsModel(
      {required String approved,
      required List<MaterialReceiveMaterialModel> materialReceiveMaterials,
      required String approvedById,
      required String warehouseStoreId,
      required String updateMaterialReceiveId})
      : super(
            approved: approved,
            warehouseStoreId: warehouseStoreId,
            approvedById: approvedById,
            materialReceiveMaterials: materialReceiveMaterials,
            updateMaterialReceiveId: updateMaterialReceiveId);

  Map<String, dynamic> toJson() {
    return {
      "warehouseStoreId": warehouseStoreId,
      "approved": approved,
      "approvedById": approvedById,
      "items": materialReceiveMaterials.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        updateMaterialReceiveId,
        warehouseStoreId,
        approved,
        approvedById,
        materialReceiveMaterials
      ];

  factory EditMaterialReceiveParamsModel.fromEntity(
      EditMaterialReceiveParamsEntity entity) {
    return EditMaterialReceiveParamsModel(
        updateMaterialReceiveId: entity.updateMaterialReceiveId,
        approved: entity.approved,
        warehouseStoreId: entity.warehouseStoreId,
        approvedById: entity.approvedById,
        materialReceiveMaterials: entity.materialReceiveMaterials
            .map((e) => MaterialReceiveMaterialModel(
                quantity: e.quantity,
                material: e.material as WarehouseProductModel,
                remark: e.remark,
                useType: e.useType,
                subStructureDescription: e.subStructureDescription,
                superStructureDescription: e.superStructureDescription))
            .toList());
  }
}

class FilterMaterialReceiveInput {
  final StringFilter? createdAt;
  final StringFilter? approvedBy;
  final StringFilter? preparedBy;
  final StringFilter? serialNumber;
  final List<String>? status;

  FilterMaterialReceiveInput(
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

class OrderByMaterialReceiveInput {
  final String? createdAt;

  OrderByMaterialReceiveInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}

enum MaterialReceiveStatus { completed, pending, declined }

MaterialReceiveStatus toMaterialReceiveStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return MaterialReceiveStatus.completed;
    case 'PENDING':
      return MaterialReceiveStatus.pending;
    case 'DECLINED':
      return MaterialReceiveStatus.declined;
    default:
      throw Exception('Invalid MaterialReceiveStatus');
  }
}

String fromMaterialReceiveStatus(MaterialReceiveStatus? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case MaterialReceiveStatus.completed:
      return 'COMPLETED';
    case MaterialReceiveStatus.pending:
      return 'PENDING';
    case MaterialReceiveStatus.declined:
      return 'DECLINED';
  }
}
