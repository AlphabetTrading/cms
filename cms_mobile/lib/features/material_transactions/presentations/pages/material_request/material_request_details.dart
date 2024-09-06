import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/details/generate_pdf_cubit.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class MaterialRequestDetailsPage extends StatefulWidget {
  final String materialRequestId;

  const MaterialRequestDetailsPage(
      {super.key, required this.materialRequestId});

  @override
  State<MaterialRequestDetailsPage> createState() =>
      _MaterialRequestDetailsPageState();
}

Future<void> saveAndOpenPdf(String base64String) async {
  try {
    Uint8List bytes = base64Decode(base64String);

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/Material Request.pdf';

    final file = File(path);
    await file.writeAsBytes(bytes);

    await OpenFile.open(path);
  } catch (e) {
    print('Error: $e');
  }
}

class _MaterialRequestDetailsPageState
    extends State<MaterialRequestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MaterialRequestDetailsCubit>()
            ..onGetMaterialRequestDetails(
                materialRequestId: widget.materialRequestId),
        ),
        BlocProvider(
            create: (context) => sl<MaterialRequestGeneratePdfCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Material Request Details"),
          actions: [
            BlocConsumer<MaterialRequestGeneratePdfCubit,
                MaterialRequestGeneratePdfState>(
              listener: (context, state) {
                if (state is MaterialRequestGeneratePdfSuccess) {
                  // Show success message and handle PDF opening
                  Fluttertoast.showToast(
                    msg: "PDF download started",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  // Open or save PDF as required
                  saveAndOpenPdf(state.materialRequest);
                } else if (state is MaterialRequestGeneratePdfFailed) {
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
                          .read<MaterialRequestGeneratePdfCubit>()
                          .onGetMaterialRequestGeneratePdf(
                              materialRequestId: widget.materialRequestId);
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
        body: BlocBuilder<MaterialRequestDetailsCubit,
            MaterialRequestDetailsState>(
          builder: (context, state) {
            if (state is MaterialRequestDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MaterialRequestDetailsFailed) {
              return Center(child: Text(state.error));
            }
            if (state is MaterialRequestDetailsSuccess) {
              final materialRequest = state.materialRequest;
              final project = materialRequest?.project;
              final requestedBy = materialRequest?.requestedBy;
              final approvedBy = materialRequest?.approvedBy;
              final materialRequestMaterials = materialRequest?.items ?? [];
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Request Info",
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
                            const SizedBox(height: 12),
                            TransactionInfoItem(
                                title: 'Material Request Number',
                                value: materialRequest?.serialNumber ?? 'N/A'),
                            const SizedBox(height: 12),
                            TransactionInfoItem(
                                title: 'Date',
                                value: materialRequest?.createdAt != null
                                    ? DateFormat('MMMM dd, yyyy HH:mm')
                                        .format(materialRequest!.createdAt!)
                                    : 'N/A'),
                            const SizedBox(height: 12),
                            TransactionInfoItem(
                                title: 'Status',
                                value: materialRequest?.status?.name ?? 'N/A'),
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
                          itemCount: materialRequestMaterials.length,
                          itemBuilder: (context, index) {
                            final materialRequestMaterial =
                                materialRequestMaterials[index];
                            final productVariant =
                                materialRequestMaterial.productVariant;
                            return MaterialTransactionMaterialItem(
                              title:
                                  '${productVariant?.product?.name} - ${productVariant?.variant}',
                              subtitle:
                                  'Requested Quantity: ${materialRequestMaterial.quantity} ${productVariant?.unitOfMeasure}',
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
                                              title: "Requested Quantity",
                                              value:
                                                  '${materialRequestMaterial.quantity} ${productVariant?.unitOfMeasure}'),
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
