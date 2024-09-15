import 'package:cms_mobile/core/entities/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
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
  final String? warehouseStoreId;
  final ProjectEntity? project;
  final WarehouseEntity? warehouseStore;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.project,
    this.warehouseStoreId,
    this.warehouseStore,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      serialNumber,
      status,
      approvedById,
      approvedBy,
      requisitionNumber,
      items,
      preparedById,
      preparedBy,
      warehouseStoreId,
      project,
      warehouseStore,
    ];
  }
}

class IssueVoucherMaterialEntity extends Equatable {
  final String? id;
  final String? productVariantId;
  final ProductVariantEntity? productVariant;
  final double? quantity;
  final String? remark;
  final double? totalCost;
  final double? unitCost;
  final SubStructureUseDescription? subStructureDescription;
  final SuperStructureUseDescription? superStructureDescription;
  final UseType? useType;
  final String? materialIssueVoucherId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const IssueVoucherMaterialEntity({
    required this.id,
    this.productVariantId,
    this.productVariant,
    this.quantity,
    this.remark,
    this.totalCost,
    this.unitCost,
    this.subStructureDescription,
    this.superStructureDescription,
    this.useType,
    this.materialIssueVoucherId,
    required this.createdAt,
    required this.updatedAt,
  });

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
      materialIssueVoucherId,
      createdAt,
      updatedAt,
    ];
  }
}

class MaterialIssueEntityListWithMeta extends Equatable {
  final List<MaterialIssueEntity> items;
  final MetaEntity meta;

  const MaterialIssueEntityListWithMeta({
    required this.meta,
    required this.items,
  });

  // empty
  factory MaterialIssueEntityListWithMeta.empty() {
    return const MaterialIssueEntityListWithMeta(
      meta: MetaEntity(count: 0, limit: 0, page: 0),
      items: [],
    );
  }

  // copyWith
  MaterialIssueEntityListWithMeta copyWith({
    List<MaterialIssueEntity>? items,
    MetaEntity? meta,
  }) {
    return MaterialIssueEntityListWithMeta(
      items: items ?? this.items,
      meta: meta ?? this.meta,
    );
  }

  @override
  List<Object?> get props => [
        items,
        meta,
      ];
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

class ApproveMaterialIssueParamsEntity extends Equatable {
  final ApproveMaterialIssueStatus decision;
  final String materialIssueId;

  const ApproveMaterialIssueParamsEntity({
    required this.decision,
    required this.materialIssueId,
  });

  @override
  List<Object?> get props => [decision, materialIssueId];
}
