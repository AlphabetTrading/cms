import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/items/data/models/item.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_return.dart';
import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:equatable/equatable.dart';

enum MaterialRequestStatus { pending, approved, declined }

class MaterialRequestEntity extends Equatable {
  final String? id;
  final String? serialNumber;
  final DateTime? date;
  final String? from;
  final String? receivingStore;
  final List<MaterialRequestItem>? items;
  final String? requestedById;
  final UserEntity? requestedBy;
  final String? approvedById;
  final UserEntity? approvedBy;
  final MaterialRequestStatus? status;
  final List<PurchaseOrderEntity>? purchaseOrders;
  final List<MaterialReceivingEntity>? materialReceiveVouchers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialRequestEntity({
    this.id,
    this.serialNumber,
    this.date,
    this.from,
    this.receivingStore,
    this.items,
    this.requestedById,
    this.requestedBy,
    this.approvedById,
    this.approvedBy,
    this.status,
    this.purchaseOrders,
    this.materialReceiveVouchers,
    this.createdAt,
    this.updatedAt,
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
  final int? listNo;
  final String? description;
  final String? unitOfMeasure;
  final double? quantityRequested;
  final double? inStockQuantity;
  final double? toBePurchasedQuantity;
  final String? remark;
  final String? materialRequestVoucherId;
  final MaterialRequestEntity? materialRequestVoucher;

  const MaterialRequestItem({
    this.id,
    this.listNo,
    this.description,
    this.unitOfMeasure,
    this.quantityRequested,
    this.inStockQuantity,
    this.toBePurchasedQuantity,
    this.remark,
    this.materialRequestVoucherId,
    this.materialRequestVoucher,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class MaterialRequestMaterialEntity extends Equatable {
  final double requestedQuantity;
  final WarehouseItemEntity? material;
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
  final Meta meta;

  MaterialRequestEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}

class MaterialRequestMaterialModel extends MaterialRequestMaterialEntity {
  const MaterialRequestMaterialModel({
    required double requestedQuantity,
    WarehouseItemModel? material,
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
