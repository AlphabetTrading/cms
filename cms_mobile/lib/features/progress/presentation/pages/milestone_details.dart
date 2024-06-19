import 'package:cms_mobile/features/progress/presentation/widgets/milestone_detail_item.dart';
import 'package:flutter/material.dart';

class MilestoneDetailsPage extends StatelessWidget {
  final String milestoneId;
  const MilestoneDetailsPage({super.key, required this.milestoneId});

  _buildMilestoneDetails(BuildContext context) {
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
              "Substructure",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              "Milestone Title",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              "Jan 12, 2024",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              "Jan 12, 2024",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              "Bamlak Alemayehu",
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
      appBar: AppBar(
        title: Text('Milestone Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Milestone',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            _buildMilestoneDetails(context),
            const SizedBox(height: 20),
            Text('Description',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(
                'Lorem ipsum dolor sit amet consectetur. Ridiculus quis porttitor odio quam. Est sem diam sed quam erat. Nibh viverra integer ornare sodales at consectetur fringilla habitasse. Urna sed elit nisl integer posuere feugiat nisl facilisis.',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 20),
            Text('Overview',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
