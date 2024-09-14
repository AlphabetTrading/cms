import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialTransferDetailsPage extends StatefulWidget {
  final String materialTransferId;
  const MaterialTransferDetailsPage(
      {super.key, required this.materialTransferId});
  @override
  State<MaterialTransferDetailsPage> createState() =>
      _MaterialTransferDetailsPageState();
}

class _MaterialTransferDetailsPageState
    extends State<MaterialTransferDetailsPage> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<MaterialTransferBloc>(context).add(
    //     GetMaterialTransferDetailsEvent(materialTransferId: widget.materialTransferId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Material Issue Details")),
      body: BlocProvider<MaterialTransferDetailsCubit>(
        create: (context) => sl<MaterialTransferDetailsCubit>()
          ..onGetMaterialTransferDetails(
              materialTransferId: widget.materialTransferId),
        child: BlocBuilder<MaterialTransferDetailsCubit,
            MaterialTransferDetailsState>(
          builder: (context, state) {
            if (state is MaterialTransferDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MaterialTransferDetailsFailed) {
              return Text(state.error);
            } else if (state is MaterialTransferDetailsSuccess) {
              final materialTransfer = state.materialTransfer;
              final project = materialTransfer?.projectId;
              final preparedBy = materialTransfer?.preparedBy;
              final approvedBy = materialTransfer?.approvedBy;
              final materialTransferMaterials = materialTransfer?.items ?? [];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Issue Info",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
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
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TransactionInfoItem(
                              title: 'Project', value: project ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Material Issue Number',
                              value: materialTransfer?.serialNumber ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Prepared by',
                              value: preparedBy?.fullName ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Date',
                              value: materialTransfer?.createdAt != null
                                  ? DateFormat('MMMM dd, yyyy HH:mm')
                                      .format(materialTransfer!.createdAt!)
                                  : 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Status',
                              value: materialTransfer?.status ?? 'N/A'),
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
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const Expanded(
                          child: Divider(),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.builder(
                        itemCount: materialTransferMaterials.length,
                        itemBuilder: (context, index) {
                          final materialTransferMaterial =
                              materialTransferMaterials[index];
                          final productVariant =
                              materialTransferMaterial.productVariant;
                          return MaterialTransactionMaterialItem(
                            title:
                                '${productVariant?.product?.name} - ${productVariant?.variant}',
                            subtitle:
                                'Issued Quantity: ${materialTransferMaterial.quantityTransferred} ${productVariant?.unitOfMeasure}',
                            iconSrc:
                                'assets/icons/transactions/light/material_issues.svg',
                            onDelete:null,
                            onEdit: null,
                            onOpen: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Wrap(children: [
                                    Column(
                                      children: [
                                        ProductDetail(
                                            title: "Name",
                                            value:
                                                '${productVariant?.product?.name} - ${productVariant?.variant}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Use Type",
                                            value: useTypeDisplay[
                                                    materialTransferMaterial
                                                        .unitCost] ??
                                                'N/A'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        materialTransferMaterial.quantityRequested ==
                                                UseType.SUB_STRUCTURE
                                            ? ProductDetail(
                                                title: "Use Description",
                                                value: subStructureUseDescriptionDisplay[
                                                        materialTransferMaterial
                                                            .materialTransferVoucherId] ??
                                                    'N/A')
                                            : ProductDetail(
                                                title: "Use Description",
                                                value: superStructureUseDescriptionDisplay[
                                                        materialTransferMaterial
                                                            .materialTransferVoucherId] ??
                                                    'N/A'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Transferred Quantity",
                                            value:
                                                '${materialTransferMaterial.quantityTransferred} ${productVariant?.unitOfMeasure}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Unit Cost",
                                            value:
                                                '${materialTransferMaterial.unitCost.toString()} ETB'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Total Cost",
                                            value:
                                                '${materialTransferMaterial.totalCost.toString()} ETB'),
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
      ),
    );
  }
}
