import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/milestone_item.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/milestone_progress_bar.dart';
import 'package:flutter/material.dart';

class MilestonesList extends StatelessWidget {
  final List<MilestoneEntity> milestones;
  const MilestonesList({super.key,required this.milestones});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: milestones.length,
        itemBuilder: (BuildContext context, int index) {
          return MilestoneItem(milestone:milestones[index]);
        },
      ),
    );
  }
}
