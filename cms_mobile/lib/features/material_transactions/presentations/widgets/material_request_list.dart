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
        color: Color.fromARGB(0, 255, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: ShapeDecoration(
            color: Color.fromARGB(255, 255, 0, 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          padding: const EdgeInsets.all(3),
          child: SvgPicture.asset(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/icons/transactions/light/material_issues.svg'
                : 'assets/icons/transactions/dark/material_issues.svg',
          ),
        ),
        title: Text(
          'Material Return ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle:  Text(
          '3 Pending | 12 Completed',
          style: Theme.of(context).textTheme.labelMedium,
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
