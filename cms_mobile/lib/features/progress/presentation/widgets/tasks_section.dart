import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/task_form.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskSection extends StatefulWidget {
  final MilestoneEntity? milestone;
  const TaskSection({super.key, required this.milestone});

  @override
  State<TaskSection> createState() => _TaskSectionState();
}

class _TaskSectionState extends State<TaskSection>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  final tabs = ["All", "Todo", "Ongoing", "Completed"];

  _buildTabItem({required int idx, required int count}) {
    return Row(
      children: [
        Text(
          tabs[idx],
        ),
        const SizedBox(width: 5),
        Container(
            child: Text(count.toString(),
                style: TextStyle(
                  color: tabController.index == idx
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                )),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: tabController.index == idx
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(15)))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TaskEntity> todo = widget.milestone?.tasks
            ?.where((element) => element.status == CompletionStatus.TODO)
            .toList() ??
        [];
    List<TaskEntity> ongoing = widget.milestone?.tasks
            ?.where((element) => element.status == CompletionStatus.ONGOING)
            .toList() ??
        [];
    List<TaskEntity> completed = widget.milestone?.tasks
            ?.where((element) => element.status == CompletionStatus.COMPLETED)
            .toList() ??
        [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CustomDropdown(
                  dropdownMenuEntries: ["All", "Assigned To Me"]
                      .map((e) => DropdownMenuEntry<String>(label: e, value: e))
                      .toList(),
                  enableFilter: false,
                  label: "",
                  onSelected: (dynamic value) {
                    print(value);
                  }),
            ),
            Flexible(
                child: ElevatedButton(
                    onPressed: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: TaskForm(
                                    milestoneId: widget.milestone?.id ?? ""),
                              )
                            ],
                          ),
                        ),
                    child: Text("Add Task")))
          ],
        ),
        TabBar(
            controller: tabController,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
            isScrollable: true,
            tabs: [
              Tab(
                  child: _buildTabItem(
                      idx: 0, count: widget.milestone?.tasks?.length ?? 0)),
              Tab(child: _buildTabItem(idx: 1, count: todo.length)),
              Tab(child: _buildTabItem(idx: 2, count: ongoing.length)),
              Tab(child: _buildTabItem(idx: 3, count: completed.length)),
            ]),
        SizedBox(
          height: 300,
          child: TabBarView(controller: tabController, children: [
            TasksList(tasks: widget.milestone?.tasks ?? []),
            TasksList(tasks: todo),
            TasksList(tasks: ongoing),
            TasksList(tasks: completed),
          ]),
        ),
      ],
    );
  }
}
