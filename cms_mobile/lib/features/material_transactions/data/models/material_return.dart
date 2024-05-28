import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/items/data/models/item.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';

class MaterialReturnModel extends MaterialIssueEntity {
  const MaterialReturnModel({
    required String id,
    required String serialNumber,
    required DateTime date,
    required String projectDetails,
    required String issuedToId,
    required UserEntity issuedTo,
    required String requisitionNumber,
    required List<IssueVoucherItem> items,
    required String preparedById,
    required UserEntity preparedBy,
    required String approvedById,
    required UserEntity approvedBy,
    required String status,
    required List<IssueVoucherItemModel> returnVoucherItems,
    required String userId,
    required UserEntity user,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(id: id);

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialReturnModel.fromJson(Map<String, dynamic> json) {
    return MaterialReturnModel(
      id: json['id'],
      serialNumber: json['serialNumber'],
      date: DateTime.parse(json['date']),
      projectDetails: json['projectDetails'],
      issuedToId: json['issuedToId'],
      issuedTo: UserModel.fromJson(json['issuedTo']),
      requisitionNumber: json['requisitionNumber'],
      items: json['items']
          .map<IssueVoucherItemModel>(
              (item) => IssueVoucherItemModel.fromJson(item))
          .toList(),
      preparedById: json['preparedById'],
      preparedBy: UserModel.fromJson(json['preparedBy']),
      approvedById: json['approvedById'],
      approvedBy: UserModel.fromJson(json['approvedBy']),
      status: json['status'],
      returnVoucherItems: json['returnVoucherItems']
          .map<IssueVoucherItemModel>(
              (item) => IssueVoucherItemModel.fromJson(item))
          .toList(),
      userId: json['userId'],
      user: UserModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class IssueVoucherItemModel extends IssueVoucherItem {
  const IssueVoucherItemModel({
    required String id,
    required int listNo,
    required String description,
    required String unitOfMeasure,
    required double quantity,
    required double unitCost,
  }) : super(
          id: id,
          listNo: listNo,
          description: description,
          unitOfMeasure: unitOfMeasure,
          quantity: quantity,
          unitCost: unitCost,
        );

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory IssueVoucherItemModel.fromJson(Map<String, dynamic> json) {
    return IssueVoucherItemModel(
      id: json['id'],
      listNo: json['listNo'],
      description: json['description'],
      unitOfMeasure: json['unitOfMeasure'],
      quantity: json['quantity'],
      unitCost: json['unitCost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listNo': listNo,
      'description': description,
      'unitOfMeasure': unitOfMeasure,
      'quantity': quantity,
      'unitCost': unitCost,
    };
  }
}

class MaterialReturnMaterialModel extends MaterialReturnMaterialEntity {
  const MaterialReturnMaterialModel({
    required double quantity,
    String? remark,
    required WarehouseItemModel material,
    required String issueVoucherId,
    required double unitCost,
  }) : super(
            quantity: quantity,
            remark: remark,
            material: material,
            issueVoucherId: issueVoucherId,
            unitCost: unitCost
            // unit: unit
            );

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'remark': remark,
    };
  }

  @override
  List<Object?> get props =>
      [remark, quantity, material, issueVoucherId, unitCost];
}

class CreateMaterialReturnParamsModel
    extends CreateMaterialReturnParamsEntity<MaterialReturnMaterialModel> {
  const CreateMaterialReturnParamsModel(
      {required String projectId,
      required List<MaterialReturnMaterialModel> materialReturnMaterials,
      required String returnedById,
      required String receivingStoreId})
      : super(
            returnedById: returnedById,
            projectId: projectId,
            materialReturnMaterials: materialReturnMaterials,
            receivingStoreId: receivingStoreId);

  @override
  List<Object?> get props =>
      [projectId, returnedById, materialReturnMaterials, receivingStoreId];

  factory CreateMaterialReturnParamsModel.fromEntity(
      CreateMaterialReturnParamsEntity entity) {
    return CreateMaterialReturnParamsModel(
        projectId: entity.projectId,
        returnedById: entity.returnedById,
        receivingStoreId: entity.receivingStoreId,
        materialReturnMaterials: entity.materialReturnMaterials
            .map((e) => MaterialReturnMaterialModel(
                quantity: e.quantity,
                remark: e.remark,
                issueVoucherId: e.issueVoucherId,
                material: e.material as WarehouseItemModel,
                unitCost: e.unitCost))
            .toList());
  }
}
