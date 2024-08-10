import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';

import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';

class MaterialProformaModel extends MaterialProformaEntity {
  const MaterialProformaModel({
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
      approvedBy: json['approvedBy'] != null
          ? UserModel.fromJson(json['approvedBy'])
          : null,
      approvedById: json['approvedById'],
      materialRequestItem: json['materialRequestItem'] != null
          ? MaterialRequestItemModel.fromJson(json['materialRequestItem'])
          : null,
      materialRequestItemId: json['materialRequestItemId'],
      photo: json['photo'],
      preparedBy: json['preparedBy'] != null
          ? UserModel.fromJson(json['preparedBy'])
          : null,
      preparedById: json['preparedById'],
      projectId: json['projectId'],
      quantity: json['quantity'],
      remark: json['remark'],
      serialNumber: json['serialNumber'],
      status: json['status'],
      totalPrice: json['totalPrice'],
      unitPrice: json['unitPrice'],
      vendor: json['vendor'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
  MaterialProformaMaterialModel({
    required super.unitPrice,
    required super.remark,
    required super.photo,
    required super.vendor,
    required super.quantity,
    required super.multipartFile
  });

  Map<String, dynamic> toJson() {
    return {
      "quantity": quantity,
      "totalPrice": unitPrice * quantity,
      "unitPrice": unitPrice,
      "remark": remark,
      "photo": photo,
      "vendor": vendor
    };
  }

  @override
  List<Object?> get props => [unitPrice, remark, photo, vendor, quantity];
}

class CreateMaterialProformaParamsModel
    extends CreateMaterialProformaParamsEntity<MaterialProformaMaterialModel> {
  const CreateMaterialProformaParamsModel(
      {required super.projectId,
      required super.preparedById,
      required super.materialProformaMaterials,
      required super.materialRequestItemId
      
      });

  Map<String, dynamic> toJson() {
    return {
      "materialRequestItemId": materialRequestItemId,
      "preparedById": preparedById,
      "projectId": projectId,
      "items": materialProformaMaterials.map((e) => e.toJson()).toList()
    };
  }

  factory CreateMaterialProformaParamsModel.fromEntity(
      CreateMaterialProformaParamsEntity entity) {
    return CreateMaterialProformaParamsModel(
        projectId: entity.projectId,
        preparedById: entity.preparedById,
        materialRequestItemId: entity.materialRequestItemId,
        materialProformaMaterials: entity.materialProformaMaterials
            .map((e) => MaterialProformaMaterialModel(
                unitPrice: e.unitPrice,
                remark: e.remark,
                multipartFile: e.multipartFile,
                quantity: e.quantity,
                vendor: e.vendor,
                photo: e.photo))
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
      // "items": materialProformaMaterials.map((e) => e.toJson()).toList(),
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
                unitPrice: e.unitPrice,
                remark: e.remark,
                quantity: e.quantity,
                multipartFile: e.multipartFile,
                vendor: e.vendor,
                photo: e.photo))
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
