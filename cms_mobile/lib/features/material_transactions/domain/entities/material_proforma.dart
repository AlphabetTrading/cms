import 'package:cms_mobile/core/entities/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

class MaterialProformaEntity extends Equatable {
  final UserEntity? approvedBy;
  final String? approvedById;
  final String id;
  final MaterialRequestItem? materialRequestItem;
  final String? materialRequestItemId;
  final String? photo;
  final UserEntity? preparedBy;
  final String? preparedById;
  final String? projectId;
  final double? quantity;
  final String? remark;
  final String? serialNumber;
  final String? status;
  final double? totalPrice;
  final double? unitPrice;
  final String? vendor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialProformaEntity({
    required this.id,
    this.approvedBy,
    this.approvedById,
    this.createdAt,
    this.materialRequestItem,
    this.materialRequestItemId,
    this.photo,
    this.preparedBy,
    this.preparedById,
    this.projectId,
    this.quantity,
    this.remark,
    this.serialNumber,
    this.status,
    this.totalPrice,
    this.unitPrice,
    this.updatedAt,
    this.vendor,
  });

  MaterialProformaEntity copyWith({
    UserEntity? approvedBy,
    String? approvedById,
    DateTime? createdAt,
    String? id,
    MaterialRequestItem? materialRequestItem,
    String? materialRequestItemId,
    String? photo,
    UserEntity? preparedBy,
    String? preparedById,
    String? projectId,
    double? quantity,
    String? remark,
    String? serialNumber,
    String? status,
    double? totalPrice,
    double? unitPrice,
    DateTime? updatedAt,
    String? vendor,
  }) =>
      MaterialProformaEntity(
        approvedBy: approvedBy ?? this.approvedBy,
        approvedById: approvedById ?? this.approvedById,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        materialRequestItem: materialRequestItem ?? this.materialRequestItem,
        materialRequestItemId:
            materialRequestItemId ?? this.materialRequestItemId,
        photo: photo ?? this.photo,
        preparedBy: preparedBy ?? this.preparedBy,
        preparedById: preparedById ?? this.preparedById,
        projectId: projectId ?? this.projectId,
        quantity: quantity ?? this.quantity,
        remark: remark ?? this.remark,
        serialNumber: serialNumber ?? this.serialNumber,
        status: status ?? this.status,
        totalPrice: totalPrice ?? this.totalPrice,
        unitPrice: unitPrice ?? this.unitPrice,
        updatedAt: updatedAt ?? this.updatedAt,
        vendor: vendor ?? this.vendor,
      );

  @override
  List<Object?> get props => [
        approvedBy,
        approvedById,
        createdAt,
        id,
        materialRequestItem,
        materialRequestItemId,
        photo,
        preparedBy,
        preparedById,
        projectId,
        quantity,
        remark,
        serialNumber,
        status,
        totalPrice,
        unitPrice,
        updatedAt,
        vendor
      ];
}

class MaterialProformaEntityListWithMeta extends Equatable {
  final List<MaterialProformaEntity> items;
  final MetaEntity meta;

  const MaterialProformaEntityListWithMeta({
    required this.meta,
    required this.items,
  });

  // empty
  factory MaterialProformaEntityListWithMeta.empty() {
    return MaterialProformaEntityListWithMeta(
      meta: MetaEntity.empty(),
      items: const [],
    );
  }

  // copyWith
  MaterialProformaEntityListWithMeta copyWith({
    List<MaterialProformaEntity>? items,
    MetaEntity? meta,
  }) {
    return MaterialProformaEntityListWithMeta(
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

class MaterialProformaMaterialEntity extends Equatable {
  final double quantity;
  final double unitPrice;
  final String? remark;
  List<String> photos;
  final String vendor;
  final MultipartFile? multipartFile;

  MaterialProformaMaterialEntity({
    required this.unitPrice,
    required this.remark,
    required this.photos,
    required this.quantity,
    required this.vendor,
    required this.multipartFile,
  });

  @override
  List<Object?> get props =>
      [unitPrice, remark, photos, vendor, quantity, multipartFile];
}

class CreateMaterialProformaParamsEntity<
    T extends MaterialProformaMaterialEntity> extends Equatable {
  final String projectId;
  final String preparedById;
  final String materialRequestItemId;
  final List<T> materialProformaMaterials;

  const CreateMaterialProformaParamsEntity(
      {required this.projectId,
      required this.preparedById,
      required this.materialProformaMaterials,
      required this.materialRequestItemId});

  @override
  String toString() {
    return 'CreateMaterialProformaParamsEntity(projectId: $projectId, preparedById: $preparedById, materialRequestItemId: $materialRequestItemId, materialProformaMaterials: $materialProformaMaterials)';
  }

  @override
  List<Object?> get props => [
        projectId,
        preparedById,
        materialProformaMaterials,
        materialRequestItemId
      ];
}

class EditMaterialProformaParamsEntity<T extends MaterialProformaMaterialEntity>
    extends Equatable {
  final String updateMaterialProformaId;
  final String warehouseStoreId;
  final String approved;
  final String approvedById;
  final List<T> materialProformaMaterials;

  const EditMaterialProformaParamsEntity(
      {required this.updateMaterialProformaId,
      required this.approved,
      required this.approvedById,
      required this.materialProformaMaterials,
      required this.warehouseStoreId});

  @override
  List<Object?> get props => [
        updateMaterialProformaId,
        warehouseStoreId,
        approved,
        approvedById,
        materialProformaMaterials
      ];
}
