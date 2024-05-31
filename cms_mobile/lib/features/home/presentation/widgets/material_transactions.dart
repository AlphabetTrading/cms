import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/utils/material_transactions_functions.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MaterialTransactionsList extends StatelessWidget {
  const MaterialTransactionsList({super.key, required this.materialRequests});

  final List<MaterialTransactionEntity> materialRequests;

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
            itemCount: materialRequests.length,
            itemBuilder: (context, index) {
              return _buildRequestItem(context, materialRequests[index]);
            },
          ),
        ],
      ),
    );
  }

  Container _buildRequestItem(
      BuildContext context, MaterialTransactionEntity materialTransaction) {
    final materialTransactionInfo =
        MaterialTransactionsHelperFunctions.getMaterialInfoByType(
            materialTransaction.type!);

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
            color: Theme.of(context).colorScheme.surfaceVariant,
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
          materialTransactionInfo['title'],
          // style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          '${materialTransaction.pendingCount} Pending | ${materialTransaction.declinedCount! + materialTransaction.approvedCount!} Completed',
          // style: Theme.of(context).textTheme.labelSmall,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            debugPrint(
                'Material Requests ' + materialTransactionInfo['routeName']);

            context.goNamed(materialTransactionInfo['routeName']!);
          },
        ),
      ),
    );
  }
}
