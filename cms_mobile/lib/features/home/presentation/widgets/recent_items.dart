import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

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
            color: const Color(0x110F4A84),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          padding: const EdgeInsets.all(3),
          child: SvgPicture.asset(
            '/icons/dashboard/analytics.svg',
          ),
        ),
        title: const Text(
          'Cement',
          style: TextStyle(
            color: Color(0xFF111416),
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0.11,
          ),
        ),
        subtitle: const Text(
          '10/02/2024',
          style: TextStyle(
            color: Color(0xFF637587),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 0.15,
          ),
        ),
        trailing: const Text(
          '-117,000',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color(0xFF111416),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 0.14,
          ),
        ));
  }
}
