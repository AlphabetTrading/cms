import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';

class MaterialTransactionModel extends MaterialTransactionEntity {
  const MaterialTransactionModel({
    required String type,
    required int pendingCount,
    required int approvedCount,
    required int declinedCount,
  }) : super(
          type: type,
          pendingCount: pendingCount,
          approvedCount: approvedCount,
          declinedCount: declinedCount,
        );

  @override
  List<Object?> get props {
    return [
      pendingCount,
      declinedCount,
      approvedCount,
      type,
    ];
  }

  factory MaterialTransactionModel.fromJson(Map<String, dynamic> json) {
    return MaterialTransactionModel(
      type: json['type'],
      pendingCount: json['pendingCount'],
      approvedCount: json['approvedCount'],
      declinedCount: json['declinedCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'pendingCount': pendingCount,
      'approvedCount': approvedCount,
      'declinedCount': declinedCount,
    };
  }
}
