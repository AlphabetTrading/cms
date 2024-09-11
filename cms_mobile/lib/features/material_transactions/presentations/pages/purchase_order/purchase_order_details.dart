import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/details/details_cubit.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOrderDetailsPage extends StatefulWidget {
  final String purchaseOrderId;

  const PurchaseOrderDetailsPage({super.key, required this.purchaseOrderId});

  @override
  State<PurchaseOrderDetailsPage> createState() =>
      _PurchaseOrderDetailsPageState();
}

class _PurchaseOrderDetailsPageState extends State<PurchaseOrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Purchase Order Details")),
      body: BlocProvider<PurchaseOrderDetailsCubit>(
        create: (context) => sl<PurchaseOrderDetailsCubit>()
          ..onGetPurchaseOrderDetails(purchaseOrderId: widget.purchaseOrderId),
        child:
            BlocBuilder<PurchaseOrderDetailsCubit, PurchaseOrderDetailsState>(
          builder: (context, state) {
            if (state is PurchaseOrderDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PurchaseOrderDetailsFailed) {
              return Center(child: Text(state.error));
            }
            if (state is PurchaseOrderDetailsSuccess) {
              final purchaseOrder = state.purchaseOrder;
              debugPrint(purchaseOrder.toString());
              debugPrint("PURCHASE IRDer");
              final project = purchaseOrder?.project;
              final preparedBy = purchaseOrder?.preparedBy;
              final approvedBy = purchaseOrder?.approvedBy;
              final purchaseOrderMaterials = purchaseOrder?.items ?? [];
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Order Info",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          Expanded(
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
                                title: 'Project',
                                value: project?.name ?? 'N/A'),
                            SizedBox(height: 12),
                            TransactionInfoItem(
                                title: 'Purchase Order Number',
                                value: purchaseOrder?.serialNumber ?? 'N/A'),
                            SizedBox(height: 12),
                            TransactionInfoItem(
                                title: 'Date',
                                value: purchaseOrder?.createdAt != null
                                    ? DateFormat('MMMM dd, yyyy HH:mm')
                                        .format(purchaseOrder!.createdAt!)
                                    : 'N/A'),
                            SizedBox(height: 12),
                            TransactionInfoItem(
                                title: 'Status',
                                value: purchaseOrder?.status?.name ?? 'N/A'),
                            SizedBox(height: 12),
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
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                          itemCount: purchaseOrderMaterials.length,
                          itemBuilder: (context, index) {
                            final purchaseOrderMaterial =
                                purchaseOrderMaterials[index];
                            // final productVariant =
                            //     purchaseOrderMaterial.productVariant;
                            final productVariant = purchaseOrderMaterial
                                    .materialRequestItem?.productVariant ??
                                purchaseOrderMaterial.proforma
                                    ?.materialRequestItem?.productVariant;

                            debugPrint(purchaseOrderMaterials.toString());
                            debugPrint(purchaseOrderMaterial.toString());
                            debugPrint(productVariant.toString());
                            debugPrint("VARIANT");

                            return MaterialTransactionMaterialItem(
                              title:
                                  '${productVariant?.product?.name} - ${productVariant?.variant}',
                              subtitle:
                                  'Ordered Quantity: ${purchaseOrderMaterial.quantity} ${productVariant?.unitOfMeasure?.name}',
                              iconSrc:
                                  'assets/icons/transactions/light/material_requests.svg',
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
                                          ProductDetail(
                                              title: "Name",
                                              value:
                                                  '${productVariant?.product?.name} - ${productVariant?.variant}'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ProductDetail(
                                              title: "Ordered Quantity",
                                              value:
                                                  '${purchaseOrderMaterial.quantity} ${productVariant?.unitOfMeasure}'),
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
