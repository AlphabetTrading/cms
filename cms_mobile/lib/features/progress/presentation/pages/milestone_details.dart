import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/details/details_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/milestone_detail_item.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/tasks_section.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('David', 25),
      _ChartData('Steve', 38),
      _ChartData('Jack', 34),
      _ChartData('Others', 52)
    ];
    _tooltip = TooltipBehavior(enable: true);
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
              milestone.stage ?? "N/A",
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
    return Scaffold(
      appBar: AppBar(title: const Text("Milestone Details")),
      body: BlocProvider<MilestoneDetailsCubit>(
        create: (context) => sl<MilestoneDetailsCubit>()
          ..onGetMilestoneDetails(milestoneId: widget.milestoneId),
        child: BlocBuilder<MilestoneDetailsCubit, MilestoneDetailsState>(
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
                    Text('Overview',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    SfCircularChart(
                        legend: Legend(isVisible: true),
                        tooltipBehavior: _tooltip,
                        series: <CircularSeries<_ChartData, String>>[
                          DoughnutSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              dataLabelMapper: (_ChartData data, _) => data.y.toString(),
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelPosition: ChartDataLabelPosition.outside,
                                  // Renders background rectangle and fills it with series color
                                  useSeriesColor: true),
                              name: 'Gold')
                        ]),
                    const SizedBox(height: 10),
                    Text('Tasks',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    TaskSection(tasks: milestone.tasks)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
