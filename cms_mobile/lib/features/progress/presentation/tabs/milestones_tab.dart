import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/list/list_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/milestones_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MilestonesTabScreen extends StatefulWidget {
  const MilestonesTabScreen({super.key});

  @override
  State<MilestonesTabScreen> createState() => _MilestonesTabScreenState();
}

class _MilestonesTabScreenState extends State<MilestonesTabScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MilestonesCubit>().onGetMilestones(
        getMilestonesParamsEntity: GetMilestonesParamsEntity(
            filterMilestoneInput: null, orderBy: null, paginationInput: null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Milestones',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 10),
            BlocBuilder<MilestonesCubit, MilestonesState>(
                builder: (context, state) {
              if (state is MilestonesLoading || state is MilestonesInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is MilestonesFailed) {
                return Text(state.error);
              }
              if (state is MilestonesSuccess) {
                return MilestonesList(milestones:state.milestoneEntityListWithMeta?.items??[]);
              }
              return Container();
            }),
          ],
        ),
      ),
    );
  }
}
