import 'package:cms_mobile/core/entities/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';
import 'package:equatable/equatable.dart';

enum MaterialRequestStatus { pending, completed, declined }

class MaterialRequestEntity extends Equatable {
  final String? id;
  final String? serialNumber;
  final List<MaterialRequestItem>? items;
  final String? projectId;
  final String? requestedById;
  final UserEntity? requestedBy;
  final String? approvedById;
  final UserEntity? approvedBy;
  final MaterialRequestStatus? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProjectEntity? project;

  const MaterialRequestEntity({
    this.id,
    this.serialNumber,
    this.items,
    this.requestedById,
    this.requestedBy,
    this.approvedById,
    this.approvedBy,
    this.status,
    this.projectId,
    this.createdAt,
    this.updatedAt,
    this.project,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class MaterialRequestItem extends Equatable {
  final String? id;
  final double? quantity;
  final String? remark;
  final String? productVariantId;
  final ProductVariantEntity? productVariant;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialRequestItem({
    this.id,
    this.quantity,
    this.remark,
    this.productVariant,
    this.productVariantId,
    this.createdAt,
    this.updatedAt,
  });

  // from json

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'remark': remark,
      'productVariantId': productVariantId,
      'productVariant': productVariant,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      quantity,
      remark,
      productVariant,
      productVariantId,
      createdAt,
      updatedAt
    ];
  }
}

class MaterialRequestMaterialEntity extends Equatable {
  final double requestedQuantity;
  final WarehouseProductEntity? material;
  final String? remark;
  // final String unit;

  const MaterialRequestMaterialEntity(
      {this.material,
      this.remark,
      // required this.unit,
      required this.requestedQuantity});

  @override
  List<Object?> get props => [material, remark, requestedQuantity];
}

class CreateMaterialRequestParamsEntity<T extends MaterialRequestMaterialEntity>
    extends Equatable {
  final String projectId;
  final String requestedById;
  final List<T> materialRequestMaterials;

  const CreateMaterialRequestParamsEntity({
    required this.projectId,
    required this.requestedById,
    required this.materialRequestMaterials,
  });

  @override
  List<Object?> get props =>
      [requestedById, projectId, materialRequestMaterials];
}

class MaterialRequestEntityListWithMeta {
  final List<MaterialRequestEntity> items;
  final MetaEntity meta;

  MaterialRequestEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}

class ApproveMaterialRequestParamsEntity extends Equatable {
  final ApproveMaterialRequestStatus decision;
  final String materialRequestId;

  const ApproveMaterialRequestParamsEntity({
    required this.decision,
    required this.materialRequestId,
  });

  @override
  List<Object?> get props => [decision, materialRequestId];
}
