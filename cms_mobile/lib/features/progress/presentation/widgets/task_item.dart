import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/presentation/utils/progress_enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class TaskItem extends StatelessWidget {
  final TaskEntity task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed(
          RouteNames.taskDetails,
          extra:task,
        );
      },
      child: Container(
        height: 100,

        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
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
                    Text(priorityDisplay[task.priority]??"N/A",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600)),
                    Text(task.name??"N/A",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    Text(task.description??"N/A",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.w400)),
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
