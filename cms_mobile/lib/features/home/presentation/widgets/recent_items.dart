import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecentItems extends StatelessWidget {
  const RecentItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 20,
            itemBuilder: (context, index) {
              return _buildRecentItem(context);
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildRecentItem(context) {
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: ShapeDecoration(
          // color: const Color(0x110F4A84),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        padding: const EdgeInsets.all(3),
        child: SvgPicture.asset(
          Theme.of(context).brightness == Brightness.dark
              ? 'assets/icons/dashboard/dark/analytics.svg'
              : 'assets/icons/dashboard/light/analytics.svg',
        ),
      ),
      title: const Text(
        'Cement',
      ),
      // titleTextStyle: Theme.of(context).listTileTheme.titleTextStyle,
      subtitle: const Text(
        '10/02/2024',
      ),
      // subtitleTextStyle: Theme.of(context).listTileTheme.subtitleTextStyle,
      trailing: const Text(
        '-117,000',
        textAlign: TextAlign.left,
      ),
      // leadingAndTrailingTextStyle:
      //     Theme.of(context).listTileTheme.leadingAndTrailingTextStyle,
    );
  }
}
