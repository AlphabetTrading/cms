// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:flutter/widgets.dart';

import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/items/data/models/item.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';

class MaterialIssueModel extends MaterialIssueEntity {
  const MaterialIssueModel({
    required String? id,
    required String? serialNumber,
    required String? status,
    required String? approvedById,
    UserModel? approvedBy,
    required String? projectDetails,
    required String? requisitionNumber,
    List<IssueVoucherMaterialModel>? items,
    required String? preparedById,
    UserModel? preparedBy,
    required String? receivedById,
    UserModel? receivedBy,
    required DateTime? createdAt,
    required DateTime? updatedAt,
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
        );

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialIssueModel.fromJson(Map<String, dynamic> json) {
    try {
      return MaterialIssueModel(
        id: json['id'],
        serialNumber: json['serialNumber'],
        projectDetails: json['projectDetails'],
        requisitionNumber: json['requisitionNumber'],
        items: json['items'].map<IssueVoucherMaterialModel>((item) {
          return IssueVoucherMaterialModel.fromJson(item);
        }).toList() as List<IssueVoucherMaterialModel>,
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
      );
    } catch (e) {
      debugPrint(
          '********** Error: in Material Issue Model $e \n $json[items]');
      return MaterialIssueModel(
        id: json['id'],
        serialNumber: json['serialNumber'],
        projectDetails: json['projectDetails'],
        requisitionNumber: json['requisitionNumber'],
        items: json['items'] ??
            json['items']
                .map<IssueVoucherMaterialModel>(
                    (item) => IssueVoucherMaterialModel.fromJson(item))
                .toList(),
        preparedById: json['preparedById'],
        preparedBy:
            json['preparedBy'] ?? UserModel.fromJson(json['preparedBy']),
        approvedById: json['approvedById'],
        approvedBy:
            json['approvedBy'] ?? UserModel.fromJson(json['approvedBy']),
        status: json['status'],
        receivedById: json['receivedById'],
        receivedBy:
            json['receivedBy'] ?? UserModel.fromJson(json['receivedBy']),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
      );
    }
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

class IssueVoucherMaterialModel extends IssueVoucherMaterialEntity {
  const IssueVoucherMaterialModel({
    required String? id,
    required ItemVariantModel? productVariant,
    required double? quantity,
    required String? remark,
    required double? totalCost,
    required double? unitCost,
    required SubStructureUseDescription? subStructureDescription,
    required SuperStructureUseDescription? superStructureDescription,
    required UseType? useType,
    required String? materialIssueVoucherId,
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
            materialIssueVoucherId: materialIssueVoucherId);

  factory IssueVoucherMaterialModel.fromJson(Map<String, dynamic> json) {
    try {
      return IssueVoucherMaterialModel(
          id: json['id'],
          productVariant: ItemVariantModel.fromJson(json['productVariant']),
          quantity: json['quantity'],
          remark: json['remark'],
          totalCost: json['totalCost'],
          unitCost: json['unitCost'],
          subStructureDescription: subStructureUseDescriptionFromString(
              json['subStructureDescription']),
          superStructureDescription: superStructureUseDescriptionFromString(
              json['superStructureDescription']),
          useType: useTypeFromString(json['useType']),
          materialIssueVoucherId: json['materialIssueVoucherId']);
    } catch (e) {
      print('Error in Issue Voucer Material Model ${e}');
    }
    return IssueVoucherMaterialModel(
        id: json['id'],
        productVariant: ItemVariantModel.fromJson(json['productVariant']),
        quantity: json['quantity'],
        remark: json['remark'],
        totalCost: json['totalCost'],
        unitCost: json['unitCost'],
        subStructureDescription: subStructureUseDescriptionFromString(
            json['subStructureDescription']),
        superStructureDescription: superStructureUseDescriptionFromString(
            json['superStructureDescription']),
        useType: useTypeFromString(json['useType']),
        materialIssueVoucherId: json['materialIssueVoucherId']);
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
      'materialIssueVoucherId': materialIssueVoucherId
    };
  }
}

class MaterialIssueListWithMeta extends MaterialIssueEntityListWithMeta {
  MaterialIssueListWithMeta({
    required Meta meta,
    required List<MaterialIssueModel> items,
  }) : super(meta: meta, items: items);

  factory MaterialIssueListWithMeta.fromJson(Map<String, dynamic> json) {
    return MaterialIssueListWithMeta(
      meta: Meta.fromJson(json['meta']),
      items: json['items']
          .map<MaterialIssueModel>((item) => MaterialIssueModel.fromJson(item))
          .toList(),
    );
  }
}

class MaterialIssueMaterialModel extends MaterialIssueMaterialEntity {
  const MaterialIssueMaterialModel(
      {required double quantity,
      String? remark,
      WarehouseItemModel? material,
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
      "productVariantId": material!.itemVariant.id,
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

class CreateMaterialIssueParamsModel
    extends CreateMaterialIssueParamsEntity<MaterialIssueMaterialModel> {
  const CreateMaterialIssueParamsModel({
    required String projectId,
    required List<MaterialIssueMaterialModel> materialIssueMaterials,
    required String preparedById,
    required String warehouseStoreId,
  }) : super(
            warehouseStoreId: warehouseStoreId,
            preparedById: preparedById,
            projectId: projectId,
            materialIssueMaterials: materialIssueMaterials);

  Map<String, dynamic> toJson() {
    return {
      "preparedById": preparedById,
      "projectId": projectId,
      "warehouseStoreId": warehouseStoreId,
      "items": materialIssueMaterials.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object?> get props => [projectId, preparedById, materialIssueMaterials];

  factory CreateMaterialIssueParamsModel.fromEntity(
      CreateMaterialIssueParamsEntity entity) {
    return CreateMaterialIssueParamsModel(
        projectId: entity.projectId,
        preparedById: entity.preparedById,
        warehouseStoreId: entity.warehouseStoreId,
        materialIssueMaterials: entity.materialIssueMaterials
            .map((e) => MaterialIssueMaterialModel(
                quantity: e.quantity,
                material: e.material as WarehouseItemModel,
                remark: e.remark,
                useType: e.useType,
                subStructureDescription: e.subStructureDescription,
                superStructureDescription: e.superStructureDescription))
            .toList());
  }
}

class EditMaterialIssueParamsModel
    extends EditMaterialIssueParamsEntity<MaterialIssueMaterialModel> {
  const EditMaterialIssueParamsModel(
      {required String approved,
      required List<MaterialIssueMaterialModel> materialIssueMaterials,
      required String approvedById,
      required String warehouseStoreId,
      required String updateMaterialIssueId})
      : super(
            approved: approved,
            warehouseStoreId: warehouseStoreId,
            approvedById: approvedById,
            materialIssueMaterials: materialIssueMaterials,
            updateMaterialIssueId: updateMaterialIssueId);

  Map<String, dynamic> toJson() {
    return {
      "warehouseStoreId": warehouseStoreId,
      "approved": approved,
      "approvedById": approvedById,
      "items": materialIssueMaterials.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        updateMaterialIssueId,
        warehouseStoreId,
        approved,
        approvedById,
        materialIssueMaterials
      ];

  factory EditMaterialIssueParamsModel.fromEntity(
      EditMaterialIssueParamsEntity entity) {
    return EditMaterialIssueParamsModel(
        updateMaterialIssueId: entity.updateMaterialIssueId,
        approved: entity.approved,
        warehouseStoreId: entity.warehouseStoreId,
        approvedById: entity.approvedById,
        materialIssueMaterials: entity.materialIssueMaterials
            .map((e) => MaterialIssueMaterialModel(
                quantity: e.quantity,
                material: e.material as WarehouseItemModel,
                remark: e.remark,
                useType: e.useType,
                subStructureDescription: e.subStructureDescription,
                superStructureDescription: e.superStructureDescription))
            .toList());
  }
}





/**
 * 
 *   final String? id;
  final String? serialNumber;
  final DateTime? date;
  final String? projectDetails;
  final String? issuedToId;
  final UserEntity? issuedTo;
  final String? requisitionNumber;
  final List<IssueVoucherItem>? items;
  final String? preparedById;
  final UserEntity? preparedBy;
  final String? approvedById;
  final UserEntity? approvedBy;
  final String? status;
  final List<MaterialReturnItem>? returnVoucherItems;
  final String? userId;
  final UserEntity? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
 */