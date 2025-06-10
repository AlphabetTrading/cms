import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/details/generate_pdf_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_state.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PurchaseOrderDetailsPage extends StatefulWidget {
  final String purchaseOrderId;

  const PurchaseOrderDetailsPage({super.key, required this.purchaseOrderId});

  @override
  State<PurchaseOrderDetailsPage> createState() =>
      _PurchaseOrderDetailsPageState();
}

Future<void> saveAndOpenPdf(String base64String) async {
  try {
    Uint8List bytes = base64Decode(base64String);

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/Purchase Order.pdf';

    final file = File(path);
    await file.writeAsBytes(bytes);

    await OpenFile.open(path);
  } catch (e) {
    print('Error: $e');
  }
}

class _PurchaseOrderDetailsPageState extends State<PurchaseOrderDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<PurchaseOrderDetailsCubit>()
              ..onGetPurchaseOrderDetails(
                  purchaseOrderId: widget.purchaseOrderId),
          ),
          BlocProvider(
              create: (context) => sl<PurchaseOrderGeneratePdfCubit>()),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Purchase Order Details"),
            actions: [
              BlocConsumer<PurchaseOrderGeneratePdfCubit,
                  PurchaseOrderGeneratePdfState>(
                listener: (context, state) {
                  if (state is PurchaseOrderGeneratePdfSuccess) {
                    // Show success message and handle PDF opening
                    Fluttertoast.showToast(
                      msg: "PDF download started",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    // Open or save PDF as required
                    saveAndOpenPdf(state.purchaseOrder);
                  } else if (state is PurchaseOrderGeneratePdfFailed) {
                    // Show error message
                    Fluttertoast.showToast(
                      msg: "Failed to generate PDF: ${state.error}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                },
                builder: (context, state) {
                  // Popup menu with the option to generate PDF
                  return PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'generate_pdf') {
                        // Trigger PDF generation
                        context
                            .read<PurchaseOrderGeneratePdfCubit>()
                            .onGetPurchaseOrderGeneratePdf(
                                purchaseOrderId: widget.purchaseOrderId);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'generate_pdf',
                        child: Text('Generate PDF'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          body:
              BlocBuilder<PurchaseOrderDetailsCubit, PurchaseOrderDetailsState>(
            builder: (context, state) {
              if (state is PurchaseOrderDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PurchaseOrderDetailsFailed) {
                return Center(child: Text(state.error));
              } else if (state is PurchaseOrderDetailsSuccess) {
                final purchaseOrder = state.purchaseOrder;
                final project = purchaseOrder?.project;
                final preparedBy = purchaseOrder?.preparedBy;
                final approvedBy = purchaseOrder?.approvedBy;
                final purchaseOrderMaterials = purchaseOrder?.items ?? [];

                final isPending = purchaseOrder?.status == "PENDING";

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      buildPurchaseOrderInfo(context, purchaseOrder, project,
                          preparedBy, approvedBy),
                      const SizedBox(height: 24),
                      buildPurchaseOrderMaterialsList(
                          context, purchaseOrderMaterials),
                      const SizedBox(height: 24),
                      BlocListener<PurchaseOrderBloc, PurchaseOrderState>(
                          listener: (context, state) {
                            if (state is ApprovePurchaseOrderSuccess) {
                              showStatusMessage(Status.SUCCESS,
                                  "Successfully updated purchase order status");
                              context.goNamed(RouteNames.purchaseOrders);

                              BlocProvider.of<PurchaseOrderBloc>(context).add(
                                GetPurchaseOrdersEvent(
                                  filterPurchaseOrderInput:
                                      FilterPurchaseOrderInput(),
                                  orderBy: OrderByPurchaseOrderInput(
                                      createdAt: "desc"),
                                  paginationInput:
                                      PaginationInput(skip: 0, take: 20),
                                  mine: false,
                                ),
                              );
                            } else if (state is ApprovePurchaseOrderFailed) {
                              showStatusMessage(Status.FAILED,
                                  state.error?.errorMessage ?? "");
                            }
                          },
                          child: buildApproveDeclineSection(
                              context, isPending, purchaseOrder, state)),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ));
  }
}

Widget buildPurchaseOrderInfo(
    BuildContext context, purchaseOrder, project, preparedBy, approvedBy) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Order Info",
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TransactionInfoItem(
                title: 'Project', value: project?.name ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Purchase Order Number',
                value: purchaseOrder?.serialNumber ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Prepared by', value: preparedBy?.fullName ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Date',
                value: purchaseOrder?.createdAt != null
                    ? DateFormat('MMMM dd, yyyy HH:mm')
                        .format(purchaseOrder!.createdAt)
                    : 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Status',
                value: fromPurchaseOrderStatus(purchaseOrder?.status) ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Approved by', value: approvedBy?.fullName ?? 'N/A'),
          ],
        ),
      ),
    ],
  );
}

Widget buildPurchaseOrderMaterialsList(
    BuildContext context, purchaseOrderMaterials) {
  return Expanded(
      child: Column(children: [
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Materials List",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
        itemCount: purchaseOrderMaterials.length,
        itemBuilder: (context, index) {
          final purchaseOrderMaterial = purchaseOrderMaterials[index];
          final productVariant =
              purchaseOrderMaterial.materialRequestItem?.productVariant ??
                  purchaseOrderMaterial
                      .proforma?.materialRequestItem?.productVariant;

          return MaterialTransactionMaterialItem(
            title:
                '${productVariant?.product?.name} - ${productVariant?.variant}',
            subtitle:
                'Ordered Quantity: ${purchaseOrderMaterial.quantity} ${fromUnitOfMeasure(productVariant?.unitOfMeasure)}',
            iconSrc: 'assets/icons/transactions/light/material_requests.svg',
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
                                '${purchaseOrderMaterial.quantity} ${fromUnitOfMeasure(productVariant?.unitOfMeasure)}'),
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
  ]));
}

Widget buildApproveDeclineSection(
    BuildContext context, isPending, purchaseOrder, state) {
  return Column(
    children: [
      if (isPending)
        ElevatedButton(
          onPressed: state is ApprovePurchaseOrderLoading
              ? null
              : () {
                  BlocProvider.of<PurchaseOrderBloc>(context).add(
                    ApprovePurchaseOrderEvent(
                      ApprovePurchaseOrderStatus.completed,
                      purchaseOrder?.id ?? "",
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is ApprovePurchaseOrderLoading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          )),
                    )
                  : const SizedBox(),
              const Text('Approve'),
            ],
          ),
        ),
      const SizedBox(height: 10),
      if (isPending)
        OutlinedButton(
          onPressed: state is ApprovePurchaseOrderLoading
              ? null
              : () {
                  BlocProvider.of<PurchaseOrderBloc>(context).add(
                    ApprovePurchaseOrderEvent(
                      ApprovePurchaseOrderStatus.declined,
                      purchaseOrder?.id ?? "",
                    ),
                  );
                },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: Colors.red),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is ApprovePurchaseOrderLoading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          )),
                    )
                  : const SizedBox(),
              const Text(
                'Decline',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
    ],
  );
}
