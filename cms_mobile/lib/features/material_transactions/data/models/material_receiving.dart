import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';

class MaterialRecevingModel extends MaterialReceivingEntity {
  const MaterialRecevingModel({
    required String? id,
    required String? serialNumber,
    required DateTime? date,
    required String? projectDetails,
    required String? supplierName,
    required String? invoiceId,
    required String? materialRequestId,
    required MaterialRequestModel? materialRequest,
    required String? purchaseOrderId,
    required PurchaseOrderModel? purchaseOrder,
    required List<MaterialReceiveItem>? items,
  }) : super(id: id);

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialRecevingModel.fromJson(Map<String, dynamic> json) {
    return MaterialRecevingModel(
      id: json['id'],
      serialNumber: json['serialNumber'],
      date: DateTime.parse(json['date']),
      projectDetails: json['projectDetails'],
      items: json['items']
          .map<MaterialReceivingItemModel>(
              (item) => MaterialReceivingItemModel.fromJson(item))
          .toList(),
      supplierName: json['supplierName'],
      invoiceId: json['invoiceId'],
      materialRequestId: json['materialRequestId'],
      materialRequest: MaterialRequestModel.fromJson(json['materialRequest']),
      purchaseOrderId: json['purchaseOrderId'],
      purchaseOrder: PurchaseOrderModel.fromJson(json['purchaseOrder']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class MaterialReceivingItemModel extends MaterialReceiveItem {
  const MaterialReceivingItemModel({
    required String id,
    required int listNo,
    required String description,
    required String unitOfMeasure,
    required int quantity,
    required double unitCost,
  }) : super(
          id: id,
          listNo: listNo,
          description: description,
          unitCost: unitCost,
          unitOfMeasure: unitOfMeasure,
        );

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialReceivingItemModel.fromJson(Map<String, dynamic> json) {
    return MaterialReceivingItemModel(
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
      'quantity': quantityReceived,
      'unitCost': unitCost,
    };
  }
}
