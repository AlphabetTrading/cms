import 'package:cms_mobile/features/items/presentation/widgets/item_detail.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MaterialIssueDetailsPage extends StatefulWidget {
  final String materialIssueId;
  const MaterialIssueDetailsPage({super.key, required this.materialIssueId});
  @override
  State<MaterialIssueDetailsPage> createState() =>
      _MaterialIssueDetailsPageState();
}

class _MaterialIssueDetailsPageState extends State<MaterialIssueDetailsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MaterialIssueBloc>(context).add(
        GetMaterialIssueDetailsEvent(materialIssueId: widget.materialIssueId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Material Issue Details")),
      body: BlocBuilder<MaterialIssueBloc, MaterialIssueState>(
        builder: (context, state) {
          if (state is MaterialIssueDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MaterialIssueDetailsFailed) {
            return Text(state.error!.errorMessage);
          } else if (state is MaterialIssueDetailsSuccess) {
            final materialIssue = state.materialIssue;
            final project = materialIssue?.project;
            final preparedBy = materialIssue?.preparedBy;
            final approvedBy = materialIssue?.approvedBy;
            final materialIssueMaterials = materialIssue?.items ?? [];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Issue Info",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const Expanded(
                        child: Divider(),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 32),
                    decoration: ShapeDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TransactionInfoItem(
                            title: 'Project', value: project?.name ?? 'N/A'),
                        const SizedBox(height: 12),
                        TransactionInfoItem(
                            title: 'Material Issue Number',
                            value: materialIssue?.serialNumber ?? 'N/A'),
                        const SizedBox(height: 12),
                        TransactionInfoItem(
                            title: 'Prepared by',
                            value: preparedBy?.fullName ?? 'N/A'),
                        const SizedBox(height: 12),
                        TransactionInfoItem(
                            title: 'Date',
                            value: materialIssue?.createdAt != null
                                ? DateFormat('MMMM dd, yyyy HH:mm')
                                    .format(materialIssue!.createdAt!)
                                : 'N/A'),
                        const SizedBox(height: 12),
                        TransactionInfoItem(
                            title: 'Status',
                            value: materialIssue?.status ?? 'N/A'),
                        const SizedBox(height: 12),
                        TransactionInfoItem(
                            title: 'Approved by',
                            value: approvedBy?.fullName ?? 'N/A'),
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
                      itemCount: materialIssueMaterials.length,
                      itemBuilder: (context, index) {
                        final materialIssueMaterial =
                            materialIssueMaterials[index];
                        final itemVariant =
                            materialIssueMaterial.productVariant;
                        return MaterialTransactionMaterialItem(
                          title:
                              '${itemVariant?.item?.name} - ${itemVariant?.variant}',
                          subtitle:
                              'Issued Quantity: ${materialIssueMaterial.quantity} ${itemVariant?.unit}',
                          iconSrc:
                              'assets/icons/transactions/light/material_issues.svg',
                          onDelete: () {},
                          onEdit: () {},
                          onOpen: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Wrap(children: [
                                  Column(
                                    children: [
                                      ItemDetail(
                                          title: "Name",
                                          value:
                                              '${itemVariant?.item?.name} - ${itemVariant?.variant}'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ItemDetail(
                                          title: "Use Type",
                                          value: useTypeDisplay[
                                                  materialIssueMaterial
                                                      .useType] ??
                                              'N/A'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      materialIssueMaterial.useType ==
                                              UseType.SUB_STRUCTURE
                                          ? ItemDetail(
                                              title: "Use Description",
                                              value: subStructureUseDescriptionDisplay[
                                                      materialIssueMaterial
                                                          .subStructureDescription] ??
                                                  'N/A')
                                          : ItemDetail(
                                              title: "Use Description",
                                              value: superStructureUseDescriptionDisplay[
                                                      materialIssueMaterial
                                                          .superStructureDescription] ??
                                                  'N/A'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ItemDetail(
                                          title: "Issued Quantity",
                                          value:
                                              '${materialIssueMaterial.quantity} ${itemVariant?.unit}'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ItemDetail(
                                          title: "Unit Cost",
                                          value:
                                              '${materialIssueMaterial.unitCost.toString()} ETB'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ItemDetail(
                                          title: "Total Cost",
                                          value:
                                              '${materialIssueMaterial.totalCost.toString()} ETB'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                ]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
