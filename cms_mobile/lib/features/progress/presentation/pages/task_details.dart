import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TaskDetails extends StatefulWidget {
  final TaskEntity task;
  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  _buildTaskDetails(BuildContext context, TaskEntity task) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task Title",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              "Priority",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              "Status",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              "Assigned to",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              "Due Date",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(width: 50),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.name ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              task.priority ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              task.status ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              task.assignedTo?.fullName ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              task.dueDate != null
                  ? DateFormat('MMMM dd, yyyy HH:mm').format(task.dueDate!)
                  : "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Task Details")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Task ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                _buildTaskDetails(context, widget.task),
                const SizedBox(height: 20),
                Text('Description',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(widget.task.description ?? 'No description provided',
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}
