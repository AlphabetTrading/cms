import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:equatable/equatable.dart';

class MaterialIssueEntity extends Equatable {
  final String? id;
  final String? serialNumber;
  final String? status;
  final String? approvedById;
  final UserEntity? approvedBy;
  final String? requisitionNumber;
  final List<IssueVoucherMaterialEntity>? items;
  final String? preparedById;
  final UserEntity? preparedBy;
  final String? receivedById;
  final UserEntity? receivedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProjectEntity? project;
  final WarehouseEntity? warehouse;

  const MaterialIssueEntity({
    this.id,
    this.serialNumber,
    this.requisitionNumber,
    this.items,
    this.preparedById,
    this.preparedBy,
    this.approvedById,
    this.approvedBy,
    this.status,
    this.receivedBy,
    this.receivedById,
    this.updatedAt,
    this.createdAt,
    this.project,
    this.warehouse,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class IssueVoucherMaterialEntity extends Equatable {
  final String? id;
  final ProductVariantEntity? productVariant;
  final double? quantity;
  final String? remark;
  final double? totalCost;
  final double? unitCost;
  final SubStructureUseDescription? subStructureDescription;
  final SuperStructureUseDescription? superStructureDescription;
  final UseType? useType;
  final String? materialIssueVoucherId;

  const IssueVoucherMaterialEntity(
      {required this.id,
      this.productVariant,
      this.quantity,
      this.remark,
      this.totalCost,
      this.unitCost,
      this.subStructureDescription,
      this.superStructureDescription,
      this.useType,
      this.materialIssueVoucherId});

  @override
  List<Object?> get props {
    return [
      id,
      productVariant,
      quantity,
      remark,
      totalCost,
      unitCost,
      subStructureDescription,
      superStructureDescription,
      useType,
      materialIssueVoucherId
    ];
  }
}

class MaterialIssueEntityListWithMeta {
  final List<MaterialIssueEntity> items;
  final Meta meta;

  MaterialIssueEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}

class MaterialIssueMaterialEntity extends Equatable {
  final double quantity;
  final String? remark;
  final WarehouseProductEntity? material;
  final UseType useType;
  final SubStructureUseDescription? subStructureDescription;
  final SuperStructureUseDescription? superStructureDescription;

  const MaterialIssueMaterialEntity({
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

class CreateMaterialIssueParamsEntity<T extends MaterialIssueMaterialEntity>
    extends Equatable {
  final String projectId;
  final String preparedById;
  final String warehouseStoreId;
  final List<T> materialIssueMaterials;

  const CreateMaterialIssueParamsEntity(
      {required this.projectId,
      required this.preparedById,
      required this.materialIssueMaterials,
      required this.warehouseStoreId});

  @override
  List<Object?> get props => [preparedById, projectId, materialIssueMaterials];
}

class EditMaterialIssueParamsEntity<T extends MaterialIssueMaterialEntity>
    extends Equatable {
  final String updateMaterialIssueId;
  final String warehouseStoreId;
  final String approved;
  final String approvedById;
  final List<T> materialIssueMaterials;

  const EditMaterialIssueParamsEntity(
      {required this.updateMaterialIssueId,
      required this.approved,
      required this.approvedById,
      required this.materialIssueMaterials,
      required this.warehouseStoreId});

  @override
  List<Object?> get props => [
        updateMaterialIssueId,
        warehouseStoreId,
        approved,
        approvedById,
        materialIssueMaterials
      ];
}
