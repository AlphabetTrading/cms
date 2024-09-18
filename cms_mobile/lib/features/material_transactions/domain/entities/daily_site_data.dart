import 'package:cms_mobile/core/entities/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:equatable/equatable.dart';

class DailySiteDataEntity extends Equatable {
  final String id;
  final String? contractor;
  final String? projectId;
  final String? status;
  final DateTime? date;
  final List<SiteTaskEntity>? tasks;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserEntity? approvedBy;
  final String? approvedById;
  final UserEntity? checkedBy;
  final String? checkedById;
  final UserEntity? preparedBy;
  final String? preparedById;

  const DailySiteDataEntity({
    required this.id,
    this.contractor,
    this.projectId,
    this.status,
    this.date,
    this.tasks,
    this.createdAt,
    this.updatedAt,
    this.approvedBy,
    this.approvedById,
    this.checkedBy,
    this.checkedById,
    this.preparedBy,
    this.preparedById,
  });

  @override
  List<Object?> get props => [
        id,
        contractor,
        projectId,
        status,
        date,
        tasks,
        createdAt,
        updatedAt,
        approvedBy,
        approvedById,
        checkedBy,
        checkedById,
        preparedBy,
        preparedById,
      ];
}

class SiteTaskEntity extends Equatable {
  final String id;
  final String? dailySiteDataId;
  final String? description;
  final double? executedQuantity;
  final String? unit;
  final List<LaborDetailEntity>? laborDetails;
  final List<MaterialDetailEntity>? materialDetails;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SiteTaskEntity({
    required this.id,
    this.dailySiteDataId,
    this.description,
    this.executedQuantity,
    this.unit,
    this.laborDetails,
    this.materialDetails,
    this.createdAt,
    this.updatedAt,
  });

  // fromJson
  factory SiteTaskEntity.fromJson(Map<String, dynamic> json) {
    return SiteTaskEntity(
      id: json['id'],
      dailySiteDataId: json['dailySiteDataId'],
      description: json['description'],
      executedQuantity: json['executedQuantity'],
      unit: json['unit'],
      laborDetails: json['laborDetails'],
      materialDetails: json['materialDetails'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dailySiteDataId': dailySiteDataId,
      'description': description,
      'executedQuantity': executedQuantity,
      'unit': unit,
      'laborDetails': laborDetails,
      'materialDetails': materialDetails,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        dailySiteDataId,
        description,
        executedQuantity,
        unit,
        laborDetails,
        materialDetails,
        createdAt,
        updatedAt,
      ];
}

class LaborDetailEntity extends Equatable {
  final String id;
  final String? dailySiteDataTaskId;
  final String? trade;
  final double? quantity;
  final double? morning;
  final double? afternoon;
  final double? overtime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LaborDetailEntity({
    required this.id,
    this.dailySiteDataTaskId,
    this.trade,
    this.quantity,
    this.morning,
    this.afternoon,
    this.overtime,
    this.createdAt,
    this.updatedAt,
  });

  // fromJson
  factory LaborDetailEntity.fromJson(Map<String, dynamic> json) {
    return LaborDetailEntity(
      id: json['id'],
      dailySiteDataTaskId: json['dailySiteDataTaskId'],
      trade: json['trade'],
      quantity: json['quantity'],
      morning: json['morning'],
      afternoon: json['afternoon'],
      overtime: json['overtime'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dailySiteDataTaskId': dailySiteDataTaskId,
      'trade': trade,
      'quantity': quantity,
      'morning': morning,
      'afternoon': afternoon,
      'overtime': overtime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        dailySiteDataTaskId,
        trade,
        quantity,
        morning,
        afternoon,
        overtime,
        createdAt,
        updatedAt,
      ];
}

class MaterialDetailEntity extends Equatable {
  final String id;
  final String? dailySiteDataTaskId;
  final String? productVariantId;
  final ProductVariantEntity? productVariant;
  final double? quantityUsed;
  final double? quantityWasted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialDetailEntity({
    required this.id,
    this.dailySiteDataTaskId,
    this.productVariantId,
    this.productVariant,
    this.quantityUsed,
    this.quantityWasted,
    this.createdAt,
    this.updatedAt,
  });

  // fromJson
  factory MaterialDetailEntity.fromJson(Map<String, dynamic> json) {
    return MaterialDetailEntity(
      id: json['id'],
      dailySiteDataTaskId: json['dailySiteDataTaskId'],
      productVariantId: json['productVariantId'],
      productVariant: json['productVariant'],
      quantityUsed: json['quantityUsed'],
      quantityWasted: json['quantityWasted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dailySiteDataTaskId': dailySiteDataTaskId,
      'productVariantId': productVariantId,
      'productVariant': productVariant,
      'quantityUsed': quantityUsed,
      'quantityWasted': quantityWasted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        dailySiteDataTaskId,
        productVariantId,
        productVariant,
        quantityUsed,
        quantityWasted,
        createdAt,
        updatedAt,
      ];
}

class DailySiteDataEntityListWithMeta extends Equatable {
  final List<DailySiteDataEntity> items;
  final MetaEntity meta;

  const DailySiteDataEntityListWithMeta({
    required this.meta,
    required this.items,
  });

  // empty
  factory DailySiteDataEntityListWithMeta.empty() {
    return const DailySiteDataEntityListWithMeta(
      meta: MetaEntity(count: 0, limit: 0, page: 0),
      items: [],
    );
  }

  // copyWith
  DailySiteDataEntityListWithMeta copyWith({
    List<DailySiteDataEntity>? items,
    MetaEntity? meta,
  }) {
    return DailySiteDataEntityListWithMeta(
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

class DailySiteDataEnitity extends Equatable {
  final String id;
  final String? contractor;
  final String? projectId;
  final String? status;
  final DateTime? date;
  final List<SiteTaskEntity>? tasks;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserEntity? approvedBy;
  final String? approvedById;
  final UserEntity? checkedBy;
  final String? checkedById;
  final UserEntity? preparedBy;
  final String? preparedById;

  const DailySiteDataEnitity({
    required this.id,
    this.contractor,
    this.projectId,
    this.status,
    this.date,
    this.tasks,
    this.createdAt,
    this.updatedAt,
    this.approvedBy,
    this.approvedById,
    this.checkedBy,
    this.checkedById,
    this.preparedBy,
    this.preparedById,
  });

  @override
  List<Object?> get props => [
        id,
        contractor,
        projectId,
        status,
        date,
        tasks,
        createdAt,
        updatedAt,
        approvedBy,
        approvedById,
        checkedBy,
        checkedById,
        preparedBy,
        preparedById,
      ];
}

class CreateDailySiteDataParamsEntity<T extends SiteTaskEntity>
    extends Equatable {
  final String projectId;
  final String preparedById;
  final List<T> tasks;

  const CreateDailySiteDataParamsEntity({
    required this.projectId,
    required this.preparedById,
    required this.tasks,
  });

  @override
  List<Object?> get props => [preparedById, projectId, tasks];
}

class EditDailySiteDataParamsEntity<T extends SiteTaskEntity>
    extends Equatable {
  final String updateDailySiteDataId;
  final String approved;
  final String approvedById;
  final List<T> tasks;

  const EditDailySiteDataParamsEntity({
    required this.updateDailySiteDataId,
    required this.approved,
    required this.approvedById,
    required this.tasks,
  });

  @override
  List<Object?> get props =>
      [updateDailySiteDataId, approved, approvedById, tasks];
}
