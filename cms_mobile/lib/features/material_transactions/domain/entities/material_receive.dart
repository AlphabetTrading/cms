import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:equatable/equatable.dart';

class MaterialReceiveEntity extends Equatable {
  final String? id;
  final String? serialNumber;
  final String? status;
  final String? approvedById;
  final UserEntity? approvedBy;
  final String? projectDetails;
  final String? requisitionNumber;
  final List<ReceiveVoucherMaterialEntity>? items;
  final String? preparedById;
  final UserEntity? preparedBy;
  final String? receivedById;
  final UserEntity? receivedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProjectEntity? project;
  final WarehouseEntity? warehouse;

  const MaterialReceiveEntity({
    this.id,
    this.serialNumber,
    this.projectDetails,
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

class ReceiveVoucherMaterialEntity extends Equatable {
  final String? id;
  final ProductVariantEntity? productVariant;
  final double? quantity;
  final String? remark;
  final double? totalCost;
  final double? unitCost;
  final SubStructureUseDescription? subStructureDescription;
  final SuperStructureUseDescription? superStructureDescription;
  final UseType? useType;
  final String? materialReceiveVoucherId;

  const ReceiveVoucherMaterialEntity(
      {required this.id,
      required this.productVariant,
      required this.quantity,
      this.remark,
      required this.totalCost,
      required this.unitCost,
      this.subStructureDescription,
      this.superStructureDescription,
      required this.useType,
      this.materialReceiveVoucherId});

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
      materialReceiveVoucherId
    ];
  }
}

class MaterialReceiveEntityListWithMeta {
  final List<MaterialReceiveEntity> items;
  final Meta meta;

  MaterialReceiveEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}


class MaterialReceiveMaterialEntity extends Equatable {
  final String purchaseOrderId;
  final IssueVoucherMaterialEntity? material;
  final double? transportationCost;
  final double? loadingCost;
  final double? unloadingCost;

  final String? remark;

  const MaterialReceiveMaterialEntity({
    required this.purchaseOrderId,
    required this.material,
    required this.transportationCost,
    required this.loadingCost,
    required this.unloadingCost,
    this.remark,
  });

  @override
  List<Object?> get props => [
        purchaseOrderId, material, transportationCost, loadingCost, unloadingCost
      ];
}

class CreateMaterialReceiveParamsEntity<T extends MaterialReceiveMaterialEntity>
    extends Equatable {
  final String projectId;
  final String receivingStoreId;
  final String returnedById;
  final List<T> materialReceiveMaterials;

  const CreateMaterialReceiveParamsEntity(
      {required this.projectId,
      required this.materialReceiveMaterials,
      required this.receivingStoreId,
      required this.returnedById
      });

  @override
  List<Object?> get props =>
      [projectId, receivingStoreId, returnedById, materialReceiveMaterials];
}


