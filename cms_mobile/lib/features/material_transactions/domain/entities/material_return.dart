import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:equatable/equatable.dart';

enum MaterialReturnStatus { pending, completed, declined }

class MaterialReturnEntity extends Equatable {
  final String? id;
  final String? serialNumber;
  final MaterialReturnStatus? status;

  final WarehouseEntity? receivingStore;
  final List<MaterialReturnItem>? items;
  final String? returnedById;
  final UserEntity? returnedBy;
  final String? receivedById;
  final UserEntity? receivedBy;

  final DateTime createdAt;
  final DateTime updatedAt;

  const MaterialReturnEntity({
    this.id,
    this.serialNumber,
    this.receivingStore,
    this.items,
    this.returnedById,
    this.returnedBy,
    this.receivedById,
    this.receivedBy,
    this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      serialNumber,
    ];
  }

  MaterialReturnEntity copyWith({
    String? id,
    String? serialNumber,
    DateTime? date,
    WarehouseEntity? receivingStore,
    List<MaterialReturnItem>? items,
    String? returnedById,
    UserEntity? returnedBy,
    String? receivedById,
    UserEntity? receivedBy,
    MaterialReturnStatus? status,
  }) {
    return MaterialReturnEntity(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      receivingStore: receivingStore ?? this.receivingStore,
      items: items ?? this.items,
      returnedById: returnedById ?? this.returnedById,
      returnedBy: returnedBy ?? this.returnedBy,
      receivedById: receivedById ?? this.receivedById,
      receivedBy: receivedBy ?? this.receivedBy,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory MaterialReturnEntity.fromJson(Map<String, dynamic> json) {
    return MaterialReturnEntity(
      id: json['id'],
      serialNumber: json['serialNumber'],
      status: MaterialReturnStatus.values
          .firstWhere((e) => e.toString() == json['status']),
      receivingStore: WarehouseEntity.fromJson(json['receivingWarehouseStore']),
      items: json['items']
          .map<MaterialReturnItem>((item) => MaterialReturnItem.fromJson(item))
          .toList(),
      returnedById: json['returnedById'],
      returnedBy: UserEntity.fromJson(json['returnedBy']),
      receivedById: json['receivedById'],
      receivedBy: UserEntity.fromJson(json['receivedBy']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serialNumber': serialNumber,
      'receivingStore': receivingStore,
      'items': items?.map((e) => e.toJson()).toList(),
      'returnedById': returnedById,
      'returnedBy': returnedBy?.toJson(),
      'receivedById': receivedById,
      'receivedBy': receivedBy?.toJson(),
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class MaterialReturnItem extends Equatable {
  final String id;
  final String? issueVoucherId;
  final MaterialIssueEntity? issueVoucher;
  final UnitOfMeasure? unitOfMeasure;
  final double? quantityReturned;
  final double? unitCost;
  final double? totalCost;
  final String? remark;
  final String? productVariantId;
  final String? materialReturnVoucherId;
  final MaterialReturnEntity? materialReturnVoucher;

  const MaterialReturnItem({
    required this.id,
    this.issueVoucherId,
    this.issueVoucher,
    this.unitOfMeasure,
    this.quantityReturned,
    this.unitCost,
    this.totalCost,
    this.remark,
    this.materialReturnVoucherId,
    this.materialReturnVoucher,
    this.productVariantId,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  MaterialReturnItem copyWith({
    String? id,
    int? listNo,
    String? issueVoucherId,
    MaterialIssueEntity? issueVoucher,
    UnitOfMeasure? unitOfMeasure,
    double? quantityReturned,
    double? unitCost,
    double? totalCost,
    String? remark,
    String? materialReturnVoucherId,
    MaterialReturnEntity? materialReturnVoucher,
    String? productVariantId,
  }) {
    return MaterialReturnItem(
      id: id ?? this.id,
      issueVoucherId: issueVoucherId ?? this.issueVoucherId,
      issueVoucher: issueVoucher ?? this.issueVoucher,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      quantityReturned: quantityReturned ?? this.quantityReturned,
      unitCost: unitCost ?? this.unitCost,
      totalCost: totalCost ?? this.totalCost,
      remark: remark ?? this.remark,
      materialReturnVoucherId:
          materialReturnVoucherId ?? this.materialReturnVoucherId,
      materialReturnVoucher:
          materialReturnVoucher ?? this.materialReturnVoucher,
      productVariantId: productVariantId ?? this.productVariantId,
    );
  }

  factory MaterialReturnItem.fromJson(Map<String, dynamic> json) {
    return MaterialReturnItem(
      id: json['id'],
      issueVoucherId: json['issueVoucherId'],
      issueVoucher: MaterialIssueModel.fromJson(json['issueVoucher']),
      unitOfMeasure: UnitOfMeasure.values
          .firstWhere((e) => e.toString() == json['unitOfMeasure']),
      quantityReturned: json['quantityReturned'],
      unitCost: json['unitCost'],
      totalCost: json['totalCost'],
      remark: json['remark'],
      materialReturnVoucherId: json['materialReturnVoucherId'],
      materialReturnVoucher:
          MaterialReturnEntity.fromJson(json['materialReturnVoucher']),
      productVariantId: json['productVariantId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issueVoucherId': issueVoucherId,
      'issueVoucher': null,
      'unitOfMeasure': unitOfMeasure,
      'quantityReturned': quantityReturned,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'remark': remark,
      'materialReturnVoucherId': materialReturnVoucherId,
      'materialReturnVoucher': null,
      'productVariantId': productVariantId,
    };
  }
}

class MaterialReturnMaterialEntity extends Equatable {
  final String issueVoucherId;
  final WarehouseProductEntity? material;
  final double quantity;
  final double unitCost;
  final String? remark;

  const MaterialReturnMaterialEntity({
    this.remark,
    required this.material,
    required this.quantity,
    required this.issueVoucherId,
    required this.unitCost,
  });

  @override
  List<Object?> get props => [
        remark,
        quantity,
        material,
        issueVoucherId,
        unitCost,
      ];
}

class CreateMaterialReturnParamsEntity<T extends MaterialReturnMaterialEntity>
    extends Equatable {
  final String projectId;
  final String returnedById;
  final String receivingStoreId;
  final List<T> materialReturnMaterials;

  const CreateMaterialReturnParamsEntity({
    required this.projectId,
    required this.returnedById,
    required this.receivingStoreId,
    required this.materialReturnMaterials,
  });

  @override
  List<Object?> get props =>
      [returnedById, receivingStoreId, projectId, materialReturnMaterials];
}

class EditMaterialReturnParamsEntity<T extends MaterialReturnMaterialEntity>
    extends Equatable {
  final String id;
  final String projectId;
  final String returnedById;
  final String receivingStoreId;
  final List<T> materialReturnMaterials;

  const EditMaterialReturnParamsEntity({
    required this.id,
    required this.projectId,
    required this.returnedById,
    required this.receivingStoreId,
    required this.materialReturnMaterials,
  });

  @override
  List<Object?> get props =>
      [id, returnedById, receivingStoreId, projectId, materialReturnMaterials];
}

class MaterialReturnEntityListWithMeta {
  final List<MaterialReturnEntity> items;
  final Meta meta;

  MaterialReturnEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}
