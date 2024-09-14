import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final DurationEntity duration;
  final ExpenditureEntity expenditure;
  final int progress;

  const DashboardEntity({
    required this.duration,
    required this.expenditure,
    required this.progress,
  });

  @override
  List<Object?> get props => [duration, expenditure, progress];
}

class DurationEntity extends Equatable {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const DurationEntity({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  List<Object?> get props => [days, hours, minutes, seconds];
}

class ExpenditureEntity extends Equatable {
  final double totalExpenditure;
  final double totalItemCost;
  final double totalLaborCost;
  final double totalTransportationCost;

  const ExpenditureEntity({
    required this.totalExpenditure,
    required this.totalItemCost,
    required this.totalLaborCost,
    required this.totalTransportationCost,
  });

  @override
  List<Object?> get props => [
        totalExpenditure,
        totalItemCost,
        totalLaborCost,
        totalTransportationCost
      ];
}

class DetailedExpenseStatsEntity extends Equatable {
  final double? totalItemCost;
  final double? totalItemCount;
  final List<SingleSpendingTransactionEntity>? spendingHistory;

  const DetailedExpenseStatsEntity({
    required this.totalItemCost,
    required this.totalItemCount,
    required this.spendingHistory,
  });

  @override
  List<Object?> get props => [
        totalItemCost,
        totalItemCount,
        spendingHistory,
      ];
}

class SingleSpendingTransactionEntity extends Equatable {
  final DateTime? date;
  final double? itemCost;
  final double? quantity;
  final ProductVariantEntity? productVariant;
  final String? productVariantId;

  const SingleSpendingTransactionEntity(
      {required this.date,
      required this.itemCost,
      required this.quantity,
      required this.productVariant,
      required this.productVariantId});

  @override
  List<Object?> get props => [
        date,
        itemCost,
        quantity,
        productVariant,
        productVariantId,
      ];
}

class DetailedStockStatsEntity extends Equatable {
  final double? totalItemBought;
  final double? totalItemLost;
  final double? totalItemUsed;
  final double? totalItemWasted;

  const DetailedStockStatsEntity(
      {required this.totalItemBought,
      required this.totalItemLost,
      required this.totalItemUsed,
      required this.totalItemWasted});

  @override
  List<Object?> get props => [
        totalItemLost,
        totalItemBought,
        totalItemUsed,
        totalItemWasted,
      ];
}
