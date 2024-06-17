import 'package:cms_mobile/core/entities/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:equatable/equatable.dart';

class MaterialTransferEntity extends Equatable {
  String? id;
  UserModel? approvedBy;
  String? approvedById;
  List<MaterialTransferItemEntity>? items;
  String? materialGroup;
  String? materialReceiveId;
  UserModel? preparedBy;
  String? preparedById;
  String? projectId;
  WarehouseEntity? receivingStore;
  String? requisitionNumber;
  String? sendingStore;
  String? sentThroughName;
  String? serialNumber;
  String? status;
  String? vehiclePlateNo;
  DateTime? updatedAt;
  DateTime? createdAt;

  MaterialTransferEntity(
      {this.id,
      this.approvedBy,
      this.approvedById,
      this.createdAt,
      this.items,
      this.materialGroup,
      this.materialReceiveId,
      this.preparedBy,
      this.preparedById,
      this.projectId,
      this.receivingStore,
      this.requisitionNumber,
      this.sendingStore,
      this.sentThroughName,
      this.serialNumber,
      this.status,
      this.updatedAt,
      this.vehiclePlateNo});

  @override
  List<Object?> get props => [
        id,
        approvedBy,
        approvedById,
        createdAt,
        items,
        materialGroup,
        materialReceiveId,
        preparedBy,
        preparedById,
        projectId,
        receivingStore,
        requisitionNumber,
        sendingStore,
        sentThroughName,
        serialNumber,
        status,
        updatedAt,
        vehiclePlateNo
      ];
}

class MaterialTransferItemEntity extends Equatable {
  String? id;
  String? materialTransferVoucherId;
  ProductVariantEntity? productVariant;
  String? productVariantId;
  int? quantityRequested;
  int? quantityTransferred;
  String? remark;
  int? totalCost;
  int? unitCost;
  DateTime createdAt;
  DateTime updatedAt;

  MaterialTransferItemEntity({
    this.id,
    this.materialTransferVoucherId,
    this.productVariant,
    this.productVariantId,
    this.quantityRequested,
    this.quantityTransferred,
    this.remark,
    this.totalCost,
    this.unitCost,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        materialTransferVoucherId,
        productVariant,
        productVariantId,
        quantityRequested,
        quantityTransferred,
        remark,
        totalCost,
        unitCost,
        createdAt,
        updatedAt
      ];

  MaterialTransferItemEntity copyWith({
    String? id,
    String? materialTransferVoucherId,
    ProductVariantEntity? productVariant,
    String? productVariantId,
    int? quantityRequested,
    int? quantityTransferred,
    String? remark,
    int? totalCost,
    int? unitCost,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaterialTransferItemEntity(
      id: id ?? this.id,
      materialTransferVoucherId:
          materialTransferVoucherId ?? this.materialTransferVoucherId,
      productVariant: productVariant ?? this.productVariant,
      productVariantId: productVariantId ?? this.productVariantId,
      quantityRequested: quantityRequested ?? this.quantityRequested,
      quantityTransferred: quantityTransferred ?? this.quantityTransferred,
      remark: remark ?? this.remark,
      totalCost: totalCost ?? this.totalCost,
      unitCost: unitCost ?? this.unitCost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MaterialTransferItemEntity.fromJson(Map<String, dynamic> json) {
    return MaterialTransferItemEntity(
      createdAt: json['createdAt'],
      id: json['id'],
      materialTransferVoucherId: json['materialTransferVoucherId'],
      productVariant: json['productVariant'] != null
          ? ProductVariantEntity.fromJson(json['productVariant'])
          : null,
      productVariantId: json['productVariantId'],
      quantityRequested: json['quantityRequested'],
      quantityTransferred: json['quantityTransferred'],
      remark: json['remark'],
      totalCost: json['totalCost'],
      unitCost: json['unitCost'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materialTransferVoucherId': materialTransferVoucherId,
      'productVariant': productVariant!.toJson(),
      'productVariantId': productVariantId,
      'quantityRequested': quantityRequested,
      'quantityTransferred': quantityTransferred,
      'remark': remark,
      'totalCost': totalCost,
      'unitCost': unitCost,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}

class CreateMaterialTransferParamsEntity<T extends MaterialTransferEntity>
    extends Equatable {
  final String projectId;
  final String returnedById;
  final String receivingStoreId;
  final List<T> materialTransferMaterials;

  const CreateMaterialTransferParamsEntity({
    required this.projectId,
    required this.returnedById,
    required this.receivingStoreId,
    required this.materialTransferMaterials,
  });

  @override
  List<Object?> get props =>
      [returnedById, receivingStoreId, projectId, materialTransferMaterials];
}

class EditMaterialTransferParamsEntity<T extends MaterialTransferEntity>
    extends Equatable {
  final String projectId;
  final String returnedById;
  final String receivingStoreId;
  final List<T> materialTransferMaterials;
  final String materialTransferId;

  const EditMaterialTransferParamsEntity({
    required this.projectId,
    required this.returnedById,
    required this.receivingStoreId,
    required this.materialTransferMaterials,
    required this.materialTransferId,
  });

  @override
  List<Object?> get props => [
        returnedById,
        receivingStoreId,
        projectId,
        materialTransferMaterials,
        materialTransferId
      ];
}

class MaterialTransferEntityListWithMeta {
  final List<MaterialTransferEntity> items;
  final Meta meta;

  MaterialTransferEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}
