// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/warehouse/data/models/warehouse.dart';

import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';

class MaterialIssueModel extends MaterialIssueEntity {
  const MaterialIssueModel({
    required String super.id,
    super.approvedById,
    UserModel? super.approvedBy,
    super.serialNumber,
    super.status,
    super.requisitionNumber,
    List<IssueVoucherMaterialModel>? super.items,
    super.preparedById,
    UserModel? super.preparedBy,
    super.warehouseStoreId,
    WarehouseModel? super.warehouseStore,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialIssueModel.fromJson(Map<String, dynamic> json) {
    return MaterialIssueModel(
      id: json['id'],
      serialNumber: json['serialNumber'],
      requisitionNumber: json['requisitionNumber'] ?? '',
      items: json['items'].map<IssueVoucherMaterialModel>((item) {
        return IssueVoucherMaterialModel.fromJson(item);
      }).toList(),
      preparedById: json['preparedById'],
      preparedBy: json['preparedBy'] != null
          ? UserModel.fromJson(json['preparedBy'])
          : null,
      approvedById: json['approvedById'],
      approvedBy: json['approvedBy'] != null
          ? UserModel.fromJson(json['approvedBy'])
          : null,
      status: json['status'],
      warehouseStoreId: json['warehouseStoreId'],
      warehouseStore: json['warehouseStore'] != null
          ? WarehouseModel.fromJson(json['warehouseStore'])
          : null,
      createdAt: json['createdAt']!= null? DateTime.parse(json['createdAt']):null,
      updatedAt: json['updatedAt']!= null? DateTime.parse(json['updatedAt']):null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serialNumber': serialNumber,
      'status': status,
      'approvedById': approvedById,
      'approvedBy': approvedBy,
      'requisitionNumber': requisitionNumber,
      'items': items,
      'preparedById': preparedById,
      'preparedBy': preparedBy,
      'warehouseStoreId': warehouseStoreId,
      'warehouseStore': warehouseStore,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class IssueVoucherMaterialModel extends IssueVoucherMaterialEntity {
  const IssueVoucherMaterialModel({
    required String? id,
    required ProductVariantModel? productVariant,
    required double? quantity,
    required String? remark,
    required double? totalCost,
    required double? unitCost,
    required SubStructureUseDescription? subStructureDescription,
    required SuperStructureUseDescription? superStructureDescription,
    required UseType? useType,
    required String? materialIssueVoucherId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          productVariant: productVariant as ProductVariantEntity,
          quantity: quantity,
          remark: remark,
          totalCost: totalCost,
          unitCost: unitCost,
          subStructureDescription: subStructureDescription,
          superStructureDescription: superStructureDescription,
          useType: useType,
          materialIssueVoucherId: materialIssueVoucherId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory IssueVoucherMaterialModel.fromJson(Map<String, dynamic> json) {
    return IssueVoucherMaterialModel(
      id: json['id'],
      productVariant: ProductVariantModel.fromJson(json['productVariant']),
      quantity: (json['quantity'] as num).toDouble(),
      remark: json['remark'],
      totalCost: (json['totalCost'] as num).toDouble(),
      unitCost: (json['unitCost'] as num).toDouble(),
      subStructureDescription:
          subStructureUseDescriptionFromString(json['subStructureDescription']),
      superStructureDescription: superStructureUseDescriptionFromString(
          json['superStructureDescription']),
      useType: useTypeFromString(json['useType']),
      materialIssueVoucherId: json['materialIssueVoucherId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productVariant': productVariant,
      'quantity': quantity,
      'remark': remark,
      'totalCost': totalCost,
      'unitCost': unitCost,
      'subStructureDescription': subStructureDescription,
      'superStructureDescription': superStructureDescription,
      'useType': useType,
      'materialIssueVoucherId': materialIssueVoucherId
    };
  }
}

class MaterialIssueListWithMeta extends MaterialIssueEntityListWithMeta {
  MaterialIssueListWithMeta({
    required MetaModel meta,
    required List<MaterialIssueModel> items,
  }) : super(meta: meta, items: items);

  factory MaterialIssueListWithMeta.fromJson(Map<String, dynamic> json) {
    return MaterialIssueListWithMeta(
      meta: MetaModel.fromJson(json['meta']),
      items: json['items']
          .map<MaterialIssueModel>((item) => MaterialIssueModel.fromJson(item))
          .toList(),
    );
  }
}

class MaterialIssueMaterialModel extends MaterialIssueMaterialEntity {
  const MaterialIssueMaterialModel(
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

class CreateMaterialIssueParamsModel
    extends CreateMaterialIssueParamsEntity<MaterialIssueMaterialModel> {
  const CreateMaterialIssueParamsModel({
    required String projectId,
    required List<MaterialIssueMaterialModel> materialIssueMaterials,
    required String preparedById,
    required String warehouseStoreId,
  }) : super(
            warehouseStoreId: warehouseStoreId,
            preparedById: preparedById,
            projectId: projectId,
            materialIssueMaterials: materialIssueMaterials);

  Map<String, dynamic> toJson() {
    return {
      "preparedById": preparedById,
      "projectId": projectId,
      "warehouseStoreId": warehouseStoreId,
      "items": materialIssueMaterials.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object?> get props => [projectId, preparedById, materialIssueMaterials];

  factory CreateMaterialIssueParamsModel.fromEntity(
      CreateMaterialIssueParamsEntity entity) {
    return CreateMaterialIssueParamsModel(
        projectId: entity.projectId,
        preparedById: entity.preparedById,
        warehouseStoreId: entity.warehouseStoreId,
        materialIssueMaterials: entity.materialIssueMaterials
            .map((e) => MaterialIssueMaterialModel(
                quantity: e.quantity,
                material: e.material as WarehouseProductModel,
                remark: e.remark,
                useType: e.useType,
                subStructureDescription: e.subStructureDescription,
                superStructureDescription: e.superStructureDescription))
            .toList());
  }
}

class EditMaterialIssueParamsModel
    extends EditMaterialIssueParamsEntity<MaterialIssueMaterialModel> {
  const EditMaterialIssueParamsModel(
      {required String approved,
      required List<MaterialIssueMaterialModel> materialIssueMaterials,
      required String approvedById,
      required String warehouseStoreId,
      required String updateMaterialIssueId})
      : super(
            approved: approved,
            warehouseStoreId: warehouseStoreId,
            approvedById: approvedById,
            materialIssueMaterials: materialIssueMaterials,
            updateMaterialIssueId: updateMaterialIssueId);

  Map<String, dynamic> toJson() {
    return {
      "warehouseStoreId": warehouseStoreId,
      "approved": approved,
      "approvedById": approvedById,
      "items": materialIssueMaterials.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        updateMaterialIssueId,
        warehouseStoreId,
        approved,
        approvedById,
        materialIssueMaterials
      ];

  factory EditMaterialIssueParamsModel.fromEntity(
      EditMaterialIssueParamsEntity entity) {
    return EditMaterialIssueParamsModel(
        updateMaterialIssueId: entity.updateMaterialIssueId,
        approved: entity.approved,
        warehouseStoreId: entity.warehouseStoreId,
        approvedById: entity.approvedById,
        materialIssueMaterials: entity.materialIssueMaterials
            .map((e) => MaterialIssueMaterialModel(
                quantity: e.quantity,
                material: e.material as WarehouseProductModel,
                remark: e.remark,
                useType: e.useType,
                subStructureDescription: e.subStructureDescription,
                superStructureDescription: e.superStructureDescription))
            .toList());
  }
}

enum MaterialIssueStatus { completed, pending, declined }

MaterialIssueStatus toMaterialIssueStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return MaterialIssueStatus.completed;
    case 'PENDING':
      return MaterialIssueStatus.pending;
    case 'DECLINED':
      return MaterialIssueStatus.declined;
    default:
      throw Exception('Invalid MaterialIssueStatus');
  }
}

String fromMaterialIssueStatus(MaterialIssueStatus? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case MaterialIssueStatus.completed:
      return 'COMPLETED';
    case MaterialIssueStatus.pending:
      return 'PENDING';
    case MaterialIssueStatus.declined:
      return 'DECLINED';
  }
}
