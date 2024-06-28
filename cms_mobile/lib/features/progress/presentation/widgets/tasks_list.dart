
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/task_item.dart';
import 'package:flutter/material.dart';

class TasksList extends StatelessWidget {
  final List<TaskEntity>? tasks;
  const TasksList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: tasks?.length??0,
          itemBuilder: (BuildContext context, int index) {
            return TaskItem(task:tasks![index]);
            
          },
        ),
      ),
    );
  }
}
