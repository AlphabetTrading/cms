// lib/features/home/presentation/widgets/duration_summary_widget.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';

class DetailedExpenseStatSummaryWidget extends StatelessWidget {
  final DetailedExpenseStatsEntity detailedExpenseStatsEntity;

  const DetailedExpenseStatSummaryWidget(
      {super.key, required this.detailedExpenseStatsEntity});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00');
    final totalExpenditureFormatted =
        formatter.format(detailedExpenseStatsEntity.totalItemCost);

    return Positioned(
      top: 30,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Amount Spent',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'ETB $totalExpenditureFormatted',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
