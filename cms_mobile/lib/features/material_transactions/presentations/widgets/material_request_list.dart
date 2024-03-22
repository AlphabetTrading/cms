import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MaterialRequestsList extends StatelessWidget {
  const MaterialRequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 20,
            itemBuilder: (context, index) {
              return _buildRequestItem(context);
            },
          ),
        ],
      ),
    );
  }

  Container _buildRequestItem(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        color: const Color(0x110F4A84),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: ShapeDecoration(
            color: const Color(0x111A80E5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          padding: const EdgeInsets.all(3),
          child: SvgPicture.asset(
            'assets/icons/requests/material_issues.svg',
          ),
        ),
        title: const Text(
          'Material Return ',
          style: TextStyle(
            color: Color(0xFF111416),
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text(
          '3 Pending | 12 Completed',
          style: TextStyle(
            color: Color(0xFF637587),
            fontSize: 10,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            debugPrint('Material Requests');
            context.goNamed(RouteNames.materialRequests,
                pathParameters: {'itemId': "123"});
          },
        ),
      ),
    );
  }
}
