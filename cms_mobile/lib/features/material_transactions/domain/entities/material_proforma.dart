import 'package:cms_mobile/core/entities/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

class MaterialProformaEntity extends Equatable {
  final UserEntity? approvedBy;
  final String? approvedById;
  final String id;
  final List<MaterialProformaItemEntity>? items;
  final MaterialRequestItem? materialRequestItem;
  final MaterialProformaItemEntity? selectedProformaItem;
  final String? materialRequestItemId;
  final UserEntity? preparedBy;
  final String? preparedById;
  final String? projectId;
  final double? quantity;
  final String? serialNumber;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialProformaEntity({
    required this.id,
    this.items,
    this.approvedBy,
    this.approvedById,
    this.createdAt,
    this.selectedProformaItem,
    this.materialRequestItem,
    this.materialRequestItemId,
    this.preparedBy,
    this.preparedById,
    this.projectId,
    this.quantity,
    this.serialNumber,
    this.status,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        approvedBy,
        approvedById,
        createdAt,
        id,
        selectedProformaItem,
        materialRequestItem,
        materialRequestItemId,
        preparedBy,
        preparedById,
        projectId,
        quantity,
        serialNumber,
        status,
        updatedAt,
      ];
}

class MaterialProformaItemEntity extends Equatable {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> photos;
  final double? quantity;
  final double? unitPrice;
  final double? totalPrice;
  final String? remark;
  final String? vendor;

  const MaterialProformaItemEntity(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.photos,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      required this.remark,
      required this.vendor});

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        photos,
        quantity,
        unitPrice,
        totalPrice,
        remark,
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
class ApproveMaterialProformaParamsEntity extends Equatable{
  final String proformaId;
  final String selectedProformaItemId;

  const ApproveMaterialProformaParamsEntity({
    required this.proformaId,
    required this.selectedProformaItemId,
  });

  @override
  List<Object?> get props => [proformaId, selectedProformaItemId];
}
