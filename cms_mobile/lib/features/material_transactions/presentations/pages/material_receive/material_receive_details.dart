import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/details/generate_pdf_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class MaterialReceiveDetailsPage extends StatefulWidget {
  final String materialReceiveId;
  const MaterialReceiveDetailsPage(
      {required this.materialReceiveId, super.key});

  @override
  State<MaterialReceiveDetailsPage> createState() =>
      _MaterialReceiveDetailsPageState();
}

Future<void> saveAndOpenPdf(String base64String) async {
  try {
    Uint8List bytes = base64Decode(base64String);

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/Material Receive.pdf';

    final file = File(path);
    await file.writeAsBytes(bytes);

    await OpenFile.open(path);
  } catch (e) {
    print('Error: $e');
  }
}

class _MaterialReceiveDetailsPageState
    extends State<MaterialReceiveDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MaterialReceiveDetailsCubit>()
            ..onGetMaterialReceiveDetails(
                materialReceiveId: widget.materialReceiveId),
        ),
        BlocProvider(
            create: (context) => sl<MaterialReceiveGeneratePdfCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Material Receive Details"),
          actions: [
            BlocConsumer<MaterialReceiveGeneratePdfCubit,
                MaterialReceiveGeneratePdfState>(
              listener: (context, state) {
                if (state is MaterialReceiveGeneratePdfSuccess) {
                  // Show success message and handle PDF opening
                  Fluttertoast.showToast(
                    msg: "PDF download started",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  // Open or save PDF as required
                  saveAndOpenPdf(state.materialReceive);
                } else if (state is MaterialReceiveGeneratePdfFailed) {
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
                          .read<MaterialReceiveGeneratePdfCubit>()
                          .onGetMaterialReceiveGeneratePdf(
                              materialReceiveId: widget.materialReceiveId);
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
        body: BlocBuilder<MaterialReceiveDetailsCubit,
            MaterialReceiveDetailsState>(
          builder: (context, state) {
            if (state is MaterialReceiveDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MaterialReceiveDetailsFailed) {
              return Center(child: Text(state.error));
            }
            if (state is MaterialReceiveDetailsSuccess) {
              final materialReceive = state.materialReceive;
              final project = materialReceive?.project;
              final preparedBy = materialReceive?.preparedBy;
              final approvedBy = materialReceive?.approvedBy;
              final materialReceiveMaterials = materialReceive?.items ?? [];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Material Receiving Info",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 32),
                      decoration: ShapeDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TransactionInfoItem(
                              title: 'Project', value: project?.name ?? 'N/A'),
                          SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Material Receiving Number',
                              value: materialReceive?.serialNumber ?? 'N/A'),
                          SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Date',
                              value: materialReceive?.createdAt != null
                                  ? DateFormat('MMMM dd, yyyy HH:mm')
                                      .format(materialReceive!.createdAt!)
                                  : 'N/A'),
                          SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Status',
                              value: materialReceive?.status ?? 'N/A'),
                          SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Approved by',
                              value: approvedBy?.fullName ?? 'N/A'),
                          SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Prepared by',
                              value: preparedBy?.fullName ?? 'N/A'),
                          SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Receiving Warehouse',
                              value: materialReceive?.warehouse?.name ?? 'N/A'),
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
                        itemCount: materialReceiveMaterials.length,
                        itemBuilder: (context, index) {
                          final materialReceiveMaterial =
                              materialReceiveMaterials[index];
                          final productVariant = materialReceiveMaterial
                                      .purchaseOrderItem?.materialRequestItem ==
                                  null
                              ? materialReceiveMaterial
                                  .purchaseOrderItem
                                  ?.proforma
                                  ?.materialRequestItem
                                  ?.productVariant
                              : materialReceiveMaterial.purchaseOrderItem
                                  ?.materialRequestItem?.productVariant;
                          return MaterialTransactionMaterialItem(
                            title:
                                '${productVariant?.product?.name} - ${productVariant?.variant}',
                            subtitle:
                                'Received Quantity: ${materialReceiveMaterial.receivedQuantity} ${unitOfMeasureDisplay(productVariant?.unitOfMeasure)}',
                            iconSrc:
                                'assets/icons/transactions/light/material_requests.svg',
                            onDelete: null,
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
                                            title: "Received Quantity",
                                            value:
                                                '${materialReceiveMaterial.receivedQuantity} ${unitOfMeasureDisplay(productVariant?.unitOfMeasure)}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Purchased Quantity",
                                            value:
                                                '${materialReceiveMaterial.purchaseOrderItem?.quantity} ${unitOfMeasureDisplay(productVariant?.unitOfMeasure)}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Unit Price",
                                            value:
                                                '${materialReceiveMaterial.purchaseOrderItem?.unitPrice}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Total Price",
                                            value:
                                                '${materialReceiveMaterial.purchaseOrderItem?.totalPrice}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Loading Cost",
                                            value:
                                                '${materialReceiveMaterial.loadingCost}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Unloading Cost",
                                            value:
                                                '${materialReceiveMaterial.unloadingCost}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Transportation Cost",
                                            value:
                                                '${materialReceiveMaterial.transportationCost}'),
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
