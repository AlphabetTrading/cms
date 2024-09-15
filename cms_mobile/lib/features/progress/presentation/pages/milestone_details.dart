import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/details/details_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/tasks_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

class MilestoneDetailsPage extends StatefulWidget {
  final String milestoneId;
  const MilestoneDetailsPage({super.key, required this.milestoneId});

  @override
  State<MilestoneDetailsPage> createState() => _MilestoneDetailsPageState();
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class _MilestoneDetailsPageState extends State<MilestoneDetailsPage> {
  // late List<_ChartData> data;
  // late TooltipBehavior _tooltip;

  @override
  void initState() {
    // _tooltip = TooltipBehavior(enable: true);
    context
        .read<MilestoneDetailsCubit>()
        .onGetMilestoneDetails(milestoneId: widget.milestoneId);
    super.initState();
  }

  _buildMilestoneDetails(BuildContext context, MilestoneEntity milestone) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Project Stage",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              "Title",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              "Start Date",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              "End Date",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              "Created By",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(width: 50),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              useTypeDisplay[milestone.stage] ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              milestone.name ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              milestone.createdAt != null
                  ? DateFormat('MMMM dd, yyyy HH:mm')
                      .format(milestone.createdAt!)
                  : "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              milestone.dueDate != null
                  ? DateFormat('MMMM dd, yyyy HH:mm').format(milestone.dueDate!)
                  : "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              milestone.createdBy?.fullName ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double calculatePercentage(int tasks, int totalTasks) {
      double result = totalTasks == 0 ? 0.0 : (tasks * 100 / totalTasks);
      return (result * 100).round() / 100;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Milestone Details")),
      body: BlocBuilder<MilestoneDetailsCubit, MilestoneDetailsState>(
        builder: (context, state) {
          if (state is MilestoneDetailsLoading ||
              state is MilestoneDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MilestoneDetailsFailed) {
            return Center(child: Text(state.error));
          }
          MilestoneEntity milestone =
              (state as MilestoneDetailsSuccess).milestone!;
          int totalTasks = milestone.tasks?.length ?? 0;
          int todo = milestone.tasks
                  ?.where((element) => element.status == CompletionStatus.TODO)
                  .length ??
              0;
          int ongoing = milestone.tasks
                  ?.where(
                      (element) => element.status == CompletionStatus.ONGOING)
                  .length ??
              0;
          int completed = milestone.tasks
                  ?.where(
                      (element) => element.status == CompletionStatus.COMPLETED)
                  .length ??
              0;
          // data = [
          //   _ChartData(
          //     'Todo',
          //     calculatePercentage(todo, totalTasks),
          //   ),
          //   _ChartData(
          //     'Ongoing',
          //     calculatePercentage(ongoing, totalTasks),
          //   ),
          //   _ChartData(
          //     'Completed',
          //     calculatePercentage(completed, totalTasks),
          //   ),
          // ];

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Milestone',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  _buildMilestoneDetails(context, milestone),
                  const SizedBox(height: 20),
                  Text('Description',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(milestone.description ?? 'No description provided',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 20),
                  Text('Milestone Progress',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  // SfCircularChart(
                  //     legend: Legend(isVisible: true),
                  //     tooltipBehavior: _tooltip,
                  //     series: <CircularSeries<_ChartData, String>>[
                  //       DoughnutSeries<_ChartData, String>(
                  //           dataSource: data,
                  //           xValueMapper: (_ChartData data, _) => data.x,
                  //           yValueMapper: (_ChartData data, _) => data.y,
                  //           dataLabelMapper: (_ChartData data, _) =>
                  //               "${data.y}%".toString(),
                  //           dataLabelSettings: DataLabelSettings(
                  //               isVisible: true,
                  //               labelPosition: ChartDataLabelPosition.outside,
                  //               showZeroValue: false,
                  //               // Renders background rectangle and fills it with series color
                  //               useSeriesColor: true),
                  //           name: 'Gold')
                  //     ]),
                  const SizedBox(height: 10),
                  Text('Tasks',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  TaskSection(milestone: milestone)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
