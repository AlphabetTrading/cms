import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/details/generate_pdf_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/daily_site_data_task_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DailySiteDataDetailsPage extends StatefulWidget {
  final String dailySiteDataId;
  const DailySiteDataDetailsPage({super.key, required this.dailySiteDataId});
  @override
  State<DailySiteDataDetailsPage> createState() =>
      _DailySiteDataDetailsPageState();
}

Future<void> saveAndOpenPdf(String base64String) async {
  try {
    Uint8List bytes = base64Decode(base64String);

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/Daily Site Data.pdf';

    final file = File(path);
    await file.writeAsBytes(bytes);

    await OpenFile.open(path);
  } catch (e) {
    print('Error: $e');
  }
}

class _DailySiteDataDetailsPageState extends State<DailySiteDataDetailsPage> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<DailySiteDataBloc>(context).add(
    //     GetDailySiteDataDetailsEvent(dailySiteDataId: widget.dailySiteDataId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<DailySiteDataDetailsCubit>()
              ..onGetDailySiteDataDetails(
                  dailySiteDataId: widget.dailySiteDataId),
          ),
          BlocProvider(
              create: (context) => sl<DailySiteDataGeneratePdfCubit>()),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Daily Site Data Details"),
            actions: [
              BlocConsumer<DailySiteDataGeneratePdfCubit,
                  DailySiteDataGeneratePdfState>(
                listener: (context, state) {
                  if (state is DailySiteDataGeneratePdfSuccess) {
                    // Show success message and handle PDF opening
                    Fluttertoast.showToast(
                      msg: "PDF download started",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    // Open or save PDF as required
                    saveAndOpenPdf(state.dailySiteData);
                  } else if (state is DailySiteDataGeneratePdfFailed) {
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
                            .read<DailySiteDataGeneratePdfCubit>()
                            .onGetDailySiteDataGeneratePdf(
                                dailySiteDataId: widget.dailySiteDataId);
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
          body: BlocProvider<DailySiteDataDetailsCubit>(
            create: (context) => sl<DailySiteDataDetailsCubit>()
              ..onGetDailySiteDataDetails(
                  dailySiteDataId: widget.dailySiteDataId),
            child: BlocBuilder<DailySiteDataDetailsCubit,
                DailySiteDataDetailsState>(
              builder: (context, state) {
                if (state is DailySiteDataDetailsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DailySiteDataDetailsFailed) {
                  return Text(state.error);
                } else if (state is DailySiteDataDetailsSuccess) {
                  final dailySiteData = state.dailySiteData;
                  final preparedBy = dailySiteData?.preparedBy;
                  final approvedBy = dailySiteData?.approvedBy;
                  final dailySiteDataTasks = dailySiteData?.tasks ?? [];

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Site Data Info",
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
                                  title: 'Project',
                                  value: approvedBy?.fullName ?? 'N/A'),
                              const SizedBox(height: 12),
                              TransactionInfoItem(
                                  title: 'Contractor',
                                  value: dailySiteData?.contractor ?? 'N/A'),
                              const SizedBox(height: 12),
                              TransactionInfoItem(
                                  title: 'Date',
                                  value: dailySiteData?.createdAt != null
                                      ? DateFormat('MMMM dd, yyyy HH:mm')
                                          .format(dailySiteData!.createdAt!)
                                      : 'N/A'),
                              const SizedBox(height: 12),
                              TransactionInfoItem(
                                  title: 'Prepared by',
                                  value: preparedBy?.fullName ?? 'N/A'),
                              const SizedBox(height: 12),
                              TransactionInfoItem(
                                  title: 'Status',
                                  value: dailySiteData?.status ?? 'N/A'),
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
                              "Tasks List",
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
                            itemCount: dailySiteDataTasks.length,
                            itemBuilder: (context, index) {
                              final dailySiteDataTask =
                                  dailySiteDataTasks[index];
                              return DailySiteDataTaskItem(
                                id: state.dailySiteData?.id ?? "",
                                taskId: dailySiteDataTask.id,
                                title: '${dailySiteDataTask.description}',
                                subtitle:
                                    'Executed Quantity: ${dailySiteDataTask.executedQuantity} ${dailySiteDataTask.unit}',
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
                                                title: "Task Description",
                                                value:
                                                    '${dailySiteDataTask.description}'),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ProductDetail(
                                                title: "Executed Quantity",
                                                value:
                                                    '${dailySiteDataTask.executedQuantity} ${dailySiteDataTask.unit}'),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ProductDetail(
                                                title: "Labor Detail",
                                                value:
                                                    '${dailySiteDataTask.laborDetails?.length ?? 0}'),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ProductDetail(
                                                title: "Materials Info",
                                                value:
                                                    '${dailySiteDataTask.materialDetails?.length ?? 0}'),
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
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ));
  }
}
