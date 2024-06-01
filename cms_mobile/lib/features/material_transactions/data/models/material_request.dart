import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:flutter/material.dart';

class MaterialRequestModel extends MaterialRequestEntity {
  const MaterialRequestModel({
    required String id,
    required String? projectId,
    required String? serialNumber,
    required MaterialRequestStatus? status,
    required String? requestedById,
    required UserModel? requestedBy,
    required String? approvedById,
    required UserModel? approvedBy,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required List<MaterialRequestItem>? items,
  }) : super(
          id: id,
          projectId: projectId,
          serialNumber: serialNumber,
          status: status,
          requestedById: requestedById,
          requestedBy: requestedBy,
          approvedById: approvedById,
          approvedBy: approvedBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
          items: items,
        );

  @override
  List<Object?> get props {
    return [
      id,
      projectId,
      serialNumber,
      status,
      requestedById,
      requestedBy,
      approvedById,
      approvedBy,
      createdAt,
      updatedAt,
    ];
  }

  factory MaterialRequestModel.fromJson(Map<String, dynamic> json) {
    UserModel? requestedBy = json['requestedBy'] != null
        ? UserModel.fromJson(json['requestedBy'])
        : null;
    final UserModel? approvedBy = json['approvedBy'] != null
        ? UserModel.fromJson(json['approvedBy'])
        : null;

    final List<MaterialRequestItem> items = json['items'] != null
        ? json['items']
            .map<MaterialRequestItem>(
                (item) => MaterialRequestItemModel.fromJson(item))
            .toList()
        : null;

    final MaterialRequestModel materialRequestModel = MaterialRequestModel(
      id: json['id'],
      projectId: json['projectId'],
      serialNumber: json['serialNumber'],
      status: toMaterialRequestStatus(json['status']),
      requestedById: json['requestedById'],
      requestedBy: requestedBy,
      approvedById: json['approvedById'],
      approvedBy: approvedBy,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      items: items,
    );

    return materialRequestModel;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serialNumber': serialNumber,
      'status': fromMaterialRequestStatus(status),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'items': items,
      'projectId': projectId,
      'requestedById': requestedById,
      'requestedBy': requestedBy,
      'approvedById': approvedById,
      'approvedBy': approvedBy,
    };
  }
}

class MaterialRequestItemModel extends MaterialRequestItem {
  const MaterialRequestItemModel({
    required String? id,
    required double? quantity,
    required String? productVariantId,
    required ProductVariantModel? productVariant,
    required String? remark,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) : super(
          id: id,
          productVariantId: productVariantId,
          quantity: quantity,
          remark: remark,
          productVariant: productVariant,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  List<Object?> get props {
    return [
      id,
      quantity,
      productVariantId,
      productVariant,
      remark,
      createdAt,
      updatedAt,
    ];
  }

  factory MaterialRequestItemModel.fromJson(Map<String, dynamic> json) {
    debugPrint('json $json');

    final MaterialRequestItemModel materialRequestItemModel =
        MaterialRequestItemModel(
      id: json['id'],
      quantity: json['quantity'],
      productVariantId: json['productVariantId'],
      productVariant: json['productVariant'] != null
          ? ProductVariantModel.fromJson(json['productVariant'])
          : null,
      remark: json['remark'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );

    return materialRequestItemModel;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'productVariantId': productVariantId,
      'productVariant': productVariant,
      'remark': remark,
    };
  }
}

class MaterialRequestMaterialModel extends MaterialRequestMaterialEntity {
  const MaterialRequestMaterialModel({
    required double requestedQuantity,
    WarehouseProductModel? material,
    required String? remark,
    // required String unit
  }) : super(
          requestedQuantity: requestedQuantity,
          material: material,
          remark: remark,
          // unit: unit
        );

  Map<String, dynamic> toJson() {
    return {
      'requestedQuantity': requestedQuantity,
      'product': material,
      'remark': remark,
    };
  }

  @override
  List<Object?> get props => [material, remark, requestedQuantity];
}

class CreateMaterialRequestParamsModel
    extends CreateMaterialRequestParamsEntity<MaterialRequestMaterialModel> {
  const CreateMaterialRequestParamsModel({
    required String projectId,
    required List<MaterialRequestMaterialModel> materialRequestMaterials,
    required String requestedById,
  }) : super(
            requestedById: requestedById,
            projectId: projectId,
            materialRequestMaterials: materialRequestMaterials);

  @override
  List<Object?> get props => [projectId, materialRequestMaterials];

  factory CreateMaterialRequestParamsModel.fromEntity(
      CreateMaterialRequestParamsEntity entity) {
    return CreateMaterialRequestParamsModel(
        projectId: entity.projectId,
        requestedById: entity.requestedById,
        materialRequestMaterials: entity.materialRequestMaterials
            .map((e) => MaterialRequestMaterialModel(
                  requestedQuantity: e.requestedQuantity,
                  material: e.material as WarehouseProductModel,
                  remark: e.remark,
                ))
            .toList());
  }
}

String fromMaterialRequestStatus(MaterialRequestStatus? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case MaterialRequestStatus.completed:
      return 'COMPLETED';
    case MaterialRequestStatus.pending:
      return 'PENDING';
    case MaterialRequestStatus.declined:
      return 'DECLINED';
  }
}

MaterialRequestStatus toMaterialRequestStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return MaterialRequestStatus.completed;
    case 'PENDING':
      return MaterialRequestStatus.pending;
    case 'DECLINED':
      return MaterialRequestStatus.declined;
    default:
      throw Exception('Invalid MaterialRequestStatus');
  }
}
