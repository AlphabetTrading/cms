import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';
import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required DurationEntity duration,
    required ExpenditureEntity expenditure,
    required int progress,
  }) : super(
          duration: duration,
          expenditure: expenditure,
          progress: progress,
        );

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      duration: DurationModel.fromJson(json['duration']),
      expenditure: ExpenditureModel.fromJson(json['expenditure']),
      progress: json['progress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': (duration as DurationModel).toJson(),
      'expenditure': (expenditure as ExpenditureModel).toJson(),
      'progress': progress,
    };
  }
}

class DurationModel extends DurationEntity {
  const DurationModel({
    required super.days,
    required super.hours,
    required super.minutes,
    required super.seconds,
  });

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(
      days: json['days'],
      hours: json['hours'],
      minutes: json['minutes'],
      seconds: json['seconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }
}

class ExpenditureModel extends ExpenditureEntity {
  const ExpenditureModel({
    required super.totalExpenditure,
    required super.totalItemCost,
    required super.totalLaborCost,
    required super.totalTransportationCost,
  });

  factory ExpenditureModel.fromJson(Map<String, dynamic> json) {
    return ExpenditureModel(
      totalExpenditure: (json['totalExpenditure'] as num).toDouble(),
      totalItemCost: (json['totalItemCost'] as num).toDouble(),
      totalLaborCost: (json['totalLaborCost'] as num).toDouble(),
      totalTransportationCost:
          (json['totalTransportationCost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalExpenditure': totalExpenditure,
      'totalItemCost': totalItemCost,
      'totalLaborCost': totalLaborCost,
      'totalTransportationCost': totalTransportationCost,
    };
  }
}

class DetailedExpenseStatsModel extends DetailedExpenseStatsEntity {
  const DetailedExpenseStatsModel({
    required super.totalItemCost,
    required super.totalItemCount,
    super.spendingHistory,
  });

  factory DetailedExpenseStatsModel.fromJson(Map<String, dynamic> json) {
    return DetailedExpenseStatsModel(
        totalItemCost: (json['totalItemCost'] as num).toDouble(),
        totalItemCount: (json['totalItemCount'] as num).toDouble(),
        spendingHistory:
            json['spendingHistory'].map<SingleSpendingTransactionModel>((item) {
          return SingleSpendingTransactionModel.fromJson(item);
        }).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItemCost': totalItemCost,
      'totalItemCount': totalItemCount,
      'spendingHistory': spendingHistory
    };
  }
}

class SingleSpendingTransactionModel extends SingleSpendingTransactionEntity {
  const SingleSpendingTransactionModel(
      {required super.date,
      required super.itemCost,
      required super.quantity,
      ProductVariantModel? super.productVariant,
      required super.productVariantId});

  factory SingleSpendingTransactionModel.fromJson(Map<String, dynamic> json) {
    return SingleSpendingTransactionModel(
      itemCost: (json['itemCost'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      productVariantId: json['productVariantId'],
      productVariant: json['productVariant'] != null
          ? ProductVariantModel.fromJson(json['productVariant'])
          : null,
      date:
          json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'itemCost': itemCost,
      'quantity': quantity,
      'productVariant': productVariant,
      'productVariantId': productVariantId
    };
  }
}

class DetailedStockStatsModel extends DetailedStockStatsEntity {
  const DetailedStockStatsModel(
      {required super.totalItemBought,
      required super.totalItemLost,
      required super.totalItemUsed,
      required super.totalItemWasted});

  factory DetailedStockStatsModel.fromJson(Map<String, dynamic> json) {
    return DetailedStockStatsModel(
      totalItemLost: (json['totalItemLost'] as num).toDouble(),
      totalItemBought: (json['totalItemBought'] as num).toDouble(),
      totalItemUsed: (json['totalItemUsed'] as num).toDouble(),
      totalItemWasted: (json['totalItemWasted'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItemLost': totalItemLost,
      'totalItemBought': totalItemBought,
      'totalItemUsed': totalItemUsed,
      'totalItemWasted': totalItemWasted,
    };
  }
}
