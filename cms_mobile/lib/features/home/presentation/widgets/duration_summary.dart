// lib/features/home/presentation/widgets/duration_summary_widget.dart
import 'package:flutter/material.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';

class DurationSummaryWidget extends StatelessWidget {
  final DashboardEntity dashboard;

  const DurationSummaryWidget({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Duration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDurationColumn(dashboard.duration.days.toString(), 'Days'),
              const SizedBox(width: 15),
              _buildDurationColumn(
                  dashboard.duration.hours.toString(), 'Hours'),
              const SizedBox(width: 15),
              _buildDurationColumn(
                  dashboard.duration.minutes.toString(), 'Minutes'),
              const SizedBox(width: 15),
              _buildDurationColumn(
                  dashboard.duration.seconds.toString(), 'Seconds'),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildDurationColumn(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
