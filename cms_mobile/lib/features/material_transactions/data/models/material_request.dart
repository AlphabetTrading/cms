import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';

class MaterialRequestModel extends MaterialRequestEntity {
  const MaterialRequestModel({
    required String id,
    required String? serialNumber,
    required DateTime? date,
    required String? from,
    required String? to,
    required List<MaterialRequestItem>? items,
  }) : super(id: id);

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialRequestModel.fromJson(Map<String, dynamic> json) {
    return MaterialRequestModel(
      id: json['id'],
      serialNumber: json['serialNumber'],
      date: DateTime.parse(json['date']),
      from: json['from'],
      to: json['to'],
      items: json['items']
          .map<MaterialRequestItemModel>(
              (item) => MaterialRequestItemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class MaterialRequestItemModel extends MaterialRequestItem {
  const MaterialRequestItemModel({
    required String id,
    required int listNo,
    required String description,
    required String unitOfMeasure,
    required double quantityRequested,
    required double unitCost,
    required double totalCost,
    required double inStockQuanity,
    required double toBePurchasedQuantity,
    required MaterialRequestModel materialRequestVoucher,
    required String materialRequestVoucherId,
    required String remark,
  }) : super(
          id: id,
          listNo: listNo,
          description: description,
          unitOfMeasure: unitOfMeasure,
          inStockQuantity: inStockQuanity,
          quantityRequested: quantityRequested,
          materialRequestVoucher: materialRequestVoucher,
          materialRequestVoucherId: materialRequestVoucherId,
          remark: remark,
          toBePurchasedQuantity: toBePurchasedQuantity,
        );

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialRequestItemModel.fromJson(Map<String, dynamic> json) {
    return MaterialRequestItemModel(
      id: json['id'],
      listNo: json['listNo'],
      description: json['description'],
      unitOfMeasure: json['unitOfMeasure'],
      unitCost: json['unitCost'],
      totalCost: json['totalCost'],
      inStockQuanity: json['inStockQuanity'],
      toBePurchasedQuantity: json['toBePurchasedQuantity'],
      materialRequestVoucher:
          MaterialRequestModel.fromJson(json['materialRequestVoucher']),
      materialRequestVoucherId: json['materialRequestVoucherId'],
      remark: json['remark'],
      quantityRequested: json['quantityRequested'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listNo': listNo,
      'description': description,
      'unitOfMeasure': unitOfMeasure,
      'quantityRequested': quantityRequested,
      'inStockQuanity': inStockQuantity,
      'toBePurchasedQuantity': toBePurchasedQuantity,
      'materialRequestVoucher': materialRequestVoucher,
      'materialRequestVoucherId': materialRequestVoucherId,
      'remark': remark,
    };
  }
}
