import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/milestone_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MilestoneItem extends StatelessWidget {
  final MilestoneEntity milestone;
  const MilestoneItem({super.key, required this.milestone});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed(
          RouteNames.milestoneDetails,
          pathParameters: {
            "milestoneId": milestone.id ?? "",
          },
        );
      },
      child: Container(
        height: 160,

        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: const Color(0x110F4A84),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(milestone.stage ?? "N/A",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600)),
                    Text(milestone.name ?? "N/A",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      // onTap: onEdit,
                      child: const Text('Edit'),
                    ),
                    PopupMenuItem<String>(
                        // onTap: onDelete,
                        child: const Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Progress",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            MilestoneProgressBar(progress: milestone.progress ?? 0.0),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/progress/start_date.svg'),
                    Text(milestone.createdAt != null
                        ? DateFormat('MMMM dd, yyyy')
                            .format(milestone.createdAt!)
                        : "N/A"),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/progress/due_date.svg'),
                    Text(milestone.dueDate != null
                        ? DateFormat('MMMM dd, yyyy').format(milestone.dueDate!)
                        : "N/A"),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/progress/tasks.svg'),
                    Text("27 Tasks"),
                  ],
                ),
              ],
            )
          ],
        ),

        // trailing: PopupMenuButton<String>(
        //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        //     // PopupMenuItem<String>(
        //     //   onTap: onEdit,
        //     //   child: const Text('Edit'),
        //     // ),
        //     // PopupMenuItem<String>(
        //     //     onTap: onDelete, child: const Text('Delete')),
        //   ],
        // ),
      ),
    );
  }
}
