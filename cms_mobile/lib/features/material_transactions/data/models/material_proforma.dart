import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';

import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';

class MaterialProformaModel extends MaterialProformaEntity {
  MaterialProformaModel({
    required UserModel? super.approvedBy,
    required super.approvedById,
    required super.createdAt,
    required super.id,
    required MaterialRequestItemModel? super.materialRequestItem,
    required super.materialRequestItemId,
    required super.photo,
    required UserModel? super.preparedBy,
    required super.preparedById,
    required super.projectId,
    required super.quantity,
    required super.remark,
    required super.serialNumber,
    required super.status,
    required super.totalPrice,
    required super.unitPrice,
    required super.updatedAt,
    required super.vendor,
  });

  factory MaterialProformaModel.fromJson(Map<String, dynamic> json) {
    return MaterialProformaModel(
      id: json['id'],
      approvedBy: UserModel.fromJson(json['approvedBy']),
      approvedById: json['approvedById'],
      createdAt: DateTime.parse(json['createdAt']),
      materialRequestItem:
          MaterialRequestItemModel.fromJson(json['materialRequestItem']),
      materialRequestItemId: json['materialRequestItemId'],
      photo: json['photo'],
      preparedBy: UserModel.fromJson(json['preparedBy']),
      preparedById: json['preparedById'],
      projectId: json['projectId'],
      quantity: json['quantity'],
      remark: json['remark'],
      serialNumber: json['serialNumber'],
      status: json['status'],
      totalPrice: json['totalPrice'],
      unitPrice: json['unitPrice'],
      updatedAt: DateTime.parse(json['updatedAt']),
      vendor: json['vendor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'approvedBy': approvedBy!.toJson(),
      'approvedById': approvedById,
      'createdAt': createdAt!.toIso8601String(),
      'materialRequestItem': materialRequestItem!.toJson(),
      'materialRequestItemId': materialRequestItemId,
      'photo': photo,
      'preparedBy': preparedBy!.toJson(),
      'preparedById': preparedById,
      'projectId': projectId,
      'quantity': quantity,
      'remark': remark,
      'serialNumber': serialNumber,
      'status': status,
      'totalPrice': totalPrice,
      'unitPrice': unitPrice,
      'updatedAt': updatedAt!.toIso8601String(),
      'vendor': vendor,
    };
  }
}

class MaterialProformaListWithMeta extends MaterialProformaEntityListWithMeta {
  const MaterialProformaListWithMeta({
    required super.meta,
    required List<MaterialProformaModel> super.items,
  });

  factory MaterialProformaListWithMeta.fromJson(Map<String, dynamic> json) {
    return MaterialProformaListWithMeta(
      meta: MetaModel.fromJson(json['meta']),
      items: json['items']
          .map<MaterialProformaModel>(
              (item) => MaterialProformaModel.fromJson(item))
          .toList(),
    );
  }
}

class MaterialProformaMaterialModel extends MaterialProformaMaterialEntity {
  const MaterialProformaMaterialModel(
      {required double quantity,
      String? remark,
      WarehouseProductModel? material,
      required UseType useType,
      SubStructureUseDescription? subStructureDescription,
      SuperStructureUseDescription? superStructureDescription})
      : super(
            quantity: quantity,
            material: material,
            remark: remark,
            useType: useType,
            subStructureDescription: subStructureDescription,
            superStructureDescription: superStructureDescription
            // unit: unit
            );

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'remark': remark,
      "productVariantId": material!.productVariant.id,
      "useType": useType.name,
      "unitCost": material!.currentPrice,
      "totalCost": material!.currentPrice * quantity,
      "subStructureDescription":
          subStructureDescription != SubStructureUseDescription.DEFAULT_VALUE
              ? subStructureDescription!.name
              : null,
      "superStructureDescription": superStructureDescription !=
              SuperStructureUseDescription.DEFAULT_VALUE
          ? superStructureDescription!.name
          : null,
    };
  }

  @override
  List<Object?> get props => [
        remark,
        quantity,
        material,
        useType,
        subStructureDescription,
        superStructureDescription
      ];
}

class CreateMaterialProformaParamsModel
    extends CreateMaterialProformaParamsEntity<MaterialProformaMaterialModel> {
  const CreateMaterialProformaParamsModel({
    required String projectId,
    required List<MaterialProformaMaterialModel> materialProformaMaterials,
    required String preparedById,
    required String warehouseStoreId,
  }) : super(
            warehouseStoreId: warehouseStoreId,
            preparedById: preparedById,
            projectId: projectId,
            materialProformaMaterials: materialProformaMaterials);

  Map<String, dynamic> toJson() {
    return {
      "preparedById": preparedById,
      "projectId": projectId,
      "warehouseStoreId": warehouseStoreId,
      "items": materialProformaMaterials.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object?> get props =>
      [projectId, preparedById, materialProformaMaterials];

  factory CreateMaterialProformaParamsModel.fromEntity(
      CreateMaterialProformaParamsEntity entity) {
    return CreateMaterialProformaParamsModel(
        projectId: entity.projectId,
        preparedById: entity.preparedById,
        warehouseStoreId: entity.warehouseStoreId,
        materialProformaMaterials: entity.materialProformaMaterials
            .map((e) => MaterialProformaMaterialModel(
                quantity: e.quantity,
                material: e.material as WarehouseProductModel,
                remark: e.remark,
                useType: e.useType,
                subStructureDescription: e.subStructureDescription,
                superStructureDescription: e.superStructureDescription))
            .toList());
  }
}

class EditMaterialProformaParamsModel
    extends EditMaterialProformaParamsEntity<MaterialProformaMaterialModel> {
  const EditMaterialProformaParamsModel(
      {required String approved,
      required List<MaterialProformaMaterialModel> materialProformaMaterials,
      required String approvedById,
      required String warehouseStoreId,
      required String updateMaterialProformaId})
      : super(
            approved: approved,
            warehouseStoreId: warehouseStoreId,
            approvedById: approvedById,
            materialProformaMaterials: materialProformaMaterials,
            updateMaterialProformaId: updateMaterialProformaId);

  Map<String, dynamic> toJson() {
    return {
      "warehouseStoreId": warehouseStoreId,
      "approved": approved,
      "approvedById": approvedById,
      "items": materialProformaMaterials.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        updateMaterialProformaId,
        warehouseStoreId,
        approved,
        approvedById,
        materialProformaMaterials
      ];

  factory EditMaterialProformaParamsModel.fromEntity(
      EditMaterialProformaParamsEntity entity) {
    return EditMaterialProformaParamsModel(
        updateMaterialProformaId: entity.updateMaterialProformaId,
        approved: entity.approved,
        warehouseStoreId: entity.warehouseStoreId,
        approvedById: entity.approvedById,
        materialProformaMaterials: entity.materialProformaMaterials
            .map((e) => MaterialProformaMaterialModel(
                quantity: e.quantity,
                material: e.material as WarehouseProductModel,
                remark: e.remark,
                useType: e.useType,
                subStructureDescription: e.subStructureDescription,
                superStructureDescription: e.superStructureDescription))
            .toList());
  }
}

enum MaterialProformaStatus { completed, pending, declined }

MaterialProformaStatus toMaterialProformaStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return MaterialProformaStatus.completed;
    case 'PENDING':
      return MaterialProformaStatus.pending;
    case 'DECLINED':
      return MaterialProformaStatus.declined;
    default:
      throw Exception('Invalid MaterialProformaStatus');
  }
}

String fromMaterialProformaStatus(MaterialProformaStatus? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case MaterialProformaStatus.completed:
      return 'COMPLETED';
    case MaterialProformaStatus.pending:
      return 'PENDING';
    case MaterialProformaStatus.declined:
      return 'DECLINED';
  }
}
