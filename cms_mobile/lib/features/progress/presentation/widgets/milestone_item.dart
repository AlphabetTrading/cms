import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/delete/delete_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/list/list_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/milestone_form.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/milestone_progress_bar.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MilestoneItem extends StatelessWidget {
  final MilestoneEntity milestone;
  const MilestoneItem({super.key, required this.milestone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeleteMilestoneCubit>(),
      child: BlocConsumer<DeleteMilestoneCubit, DeleteMilestoneState>(
        listener: (context, state) {
          if (state is DeleteMilestoneSuccess) {
            showStatusMessage(Status.SUCCESS, "Milestone deleted successfully");
            context.read<MilestonesCubit>().onGetMilestones(
                getMilestonesParamsEntity: GetMilestonesParamsEntity(
                    filterMilestoneInput: null,
                    orderBy: null,
                    paginationInput: null));
          } else if (state is DeleteMilestoneFailed) {
            showStatusMessage(Status.FAILED, state.error);
          }
        },
        builder: (context, state) {
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
              height: 170,

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
                  (state is DeleteMilestoneLoading)
                      ? LinearProgressIndicator()
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(useTypeDisplay[milestone.stage] ?? "N/A",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                            onTap: () => showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: MilestoneForm(
                                      isEdit: true,
                                      milestone: milestone,
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
                                    .read<DeleteMilestoneCubit>()
                                    .onDeleteMilestone(
                                        milestoneId: milestone.id ?? "");
                              },
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
                          SvgPicture.asset(
                              'assets/icons/progress/start_date.svg'),
                          Text(milestone.createdAt != null
                              ? DateFormat('MMMM dd, yyyy')
                                  .format(milestone.createdAt!)
                              : "N/A",style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                              'assets/icons/progress/due_date.svg'),
                          Text(milestone.dueDate != null
                              ? DateFormat('MMMM dd, yyyy')
                                  .format(milestone.dueDate!)
                              : "N/A",style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/progress/tasks.svg'),
                          Text("${milestone.tasks?.length} Tasks",style: Theme.of(context).textTheme.labelSmall,),
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
        },
      ),
    );
  }
}
