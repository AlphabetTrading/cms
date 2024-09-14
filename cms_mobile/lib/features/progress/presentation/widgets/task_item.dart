import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/details/details_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/task/delete/delete_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/utils/progress_enums.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/task_form.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class TaskItem extends StatelessWidget {
  final TaskEntity task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeleteTaskCubit>(),
      child: BlocConsumer<DeleteTaskCubit, DeleteTaskState>(
        listener: (context, state) {
          if (state is DeleteTaskSuccess) {
            showStatusMessage(Status.SUCCESS, "Task deleted successfully");
            context
                .read<MilestoneDetailsCubit>()
                .onGetMilestoneDetails(milestoneId: task.milestoneId ?? "");
          } else if (state is DeleteTaskFailed) {
            showStatusMessage(Status.FAILED, state.error);
          }
        },
        builder: (context, state) {
          return InkWell(
            onTap: () {
              context.goNamed(
                RouteNames.taskDetails,
                extra: task,
              );
            },
            child: Container(
              height: 100,

              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (state is DeleteTaskLoading)
                      ? LinearProgressIndicator()
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(priorityDisplay[task.priority] ?? "N/A",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600)),
                          Text(task.name ?? "N/A",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                          Text(task.description ?? "N/A",
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
                            onTap: () => showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: TaskForm(
                                      isEdit: true,
                                      milestoneId: task.milestoneId,
                                      task: task,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            child: const Text('Edit'),
                          ),
                          PopupMenuItem<String>(
                              onTap: () {
                                context
                                    .read<DeleteTaskCubit>()
                                    .onDeleteTask(
                                        taskId: task.id ?? "");
                              },
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
        },
      ),
    );
  }
}
