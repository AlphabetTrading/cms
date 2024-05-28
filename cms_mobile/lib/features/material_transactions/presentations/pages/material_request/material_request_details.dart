import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:flutter/material.dart';

class MaterialRequestDetailsPage extends StatelessWidget {
  const MaterialRequestDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Request Info",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Expanded(
                    child: Divider(),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TransactionInfoItem(title: 'Project', value: 'Bulbula'),
                    SizedBox(height: 12),
                    TransactionInfoItem(
                        title: 'Material Request Number', value: 'MRQ/012'),
                    SizedBox(height: 12),
                    TransactionInfoItem(title: 'Date', value: '10/02/24'),
                    SizedBox(height: 12),
                    TransactionInfoItem(title: 'Status', value: 'Approved'),
                    SizedBox(height: 12),
                    TransactionInfoItem(
                        title: 'Approved by', value: 'Bamlak Tesfaye'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Materials List",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Expanded(
                    child: Divider(),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return MaterialTransactionMaterialItem(
                      title: 'Cement',
                      subtitle: 'Requested Amount: 10 Kg',
                      iconSrc:
                          'assets/icons/transactions/light/material_issues.svg',
                      onDelete: () {},
                      onEdit: () {},
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
