import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:equatable/equatable.dart';

class MaterialIssueEntity extends Equatable {
  final String? id;
  final String? serialNumber;
  final String? status;
  final String? approvedById;
  final UserEntity? approvedBy;
  final String? projectDetails;
  final String? requisitionNumber;
  final List<IssueVoucherItem>? items;
  final String? preparedById;
  final UserEntity? preparedBy;
  final String? receivedById;
  final UserEntity? receivedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialIssueEntity({
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
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class IssueVoucherItem extends Equatable {
  final String? id;
  final int? listNo;
  final String? description;
  final String? unitOfMeasure;
  final double? quantity;
  final double? unitCost;
  final double? totalCost;
  final String? remark;
  final String? materialIssueVoucherId;
  final MaterialIssueEntity? materialIssueVoucher;

  const IssueVoucherItem({
    this.id,
    this.listNo,
    this.description,
    this.unitOfMeasure,
    this.quantity,
    this.unitCost,
    this.totalCost,
    this.remark,
    this.materialIssueVoucherId,
    this.materialIssueVoucher,
  });

  @override
  List<Object?> get props {
    return [
      id,
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
  final WarehouseItemEntity? material;
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

  const CreateMaterialIssueParamsEntity({
    required this.projectId,
    required this.preparedById,
    required this.materialIssueMaterials,
    required this.warehouseStoreId
  });

  @override
  List<Object?> get props => [preparedById, projectId, materialIssueMaterials];
}
