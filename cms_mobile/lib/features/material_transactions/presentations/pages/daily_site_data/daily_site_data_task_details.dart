import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/daily_site_data_task_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailySiteDataTaskDetailsPage extends StatefulWidget {
  final String dailySiteDataId;
  final String dailySiteDataTaskId;
  const DailySiteDataTaskDetailsPage(
      {super.key,
      required this.dailySiteDataId,
      required this.dailySiteDataTaskId});
  @override
  State<DailySiteDataTaskDetailsPage> createState() =>
      _DailySiteDataTaskDetailsPageState();
}

class _DailySiteDataTaskDetailsPageState
    extends State<DailySiteDataTaskDetailsPage> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<DailySiteDataBloc>(context).add(
    //     GetDailySiteDataDetailsEvent(dailySiteDataId: widget.dailySiteDataId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Details")),
      body: BlocProvider<DailySiteDataDetailsCubit>(
        create: (context) => sl<DailySiteDataDetailsCubit>()
          ..onGetDailySiteDataDetails(dailySiteDataId: widget.dailySiteDataId),
        child:
            BlocBuilder<DailySiteDataDetailsCubit, DailySiteDataDetailsState>(
          builder: (context, state) {
            if (state is DailySiteDataDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DailySiteDataDetailsFailed) {
              return Text(state.error);
            } else if (state is DailySiteDataDetailsSuccess) {
              final dailySiteData = state.dailySiteData;
              final dailySiteDataTasks = dailySiteData?.tasks ?? [];
              final taskData = dailySiteDataTasks.firstWhere(
                  (element) => element.id == widget.dailySiteDataTaskId);
              final laborDetails = taskData.laborDetails ?? [];
              final materialDetails = taskData.materialDetails ?? [];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Daily Site Data Task Info",
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
                              title: 'Task Name',
                              value: taskData.description ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Executed Quantity',
                              value: taskData.executedQuantity.toString()),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Unit of Measure',
                              value: taskData.unit ?? 'N/A'),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Labor",
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
                        itemCount: laborDetails.length,
                        itemBuilder: (context, index) {
                          final laborDetail = laborDetails[index];
                          debugPrint(laborDetail.toJson().toString());
                          debugPrint("Labors");

                          return DailySiteDataTaskItem(
                            id: "",
                            taskId: "",
                            title: '${laborDetail.trade}',
                            subtitle: '# of workers: ${laborDetail.quantity}',
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(), // Adjust the width of each column as needed
                                          1: FlexColumnWidth(),
                                          2: FlexColumnWidth(),
                                        },
                                        children: [
                                          TableRow(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Trade",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium),
                                                  Text(
                                                      laborDetail.trade ??
                                                          "N/A",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                ],
                                              ),
                                              const Column(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Number",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium),
                                                  Text(
                                                      (laborDetail.quantity ??
                                                              0)
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const TableRow(
                                            children: [
                                              SizedBox(
                                                  height:
                                                      20), // Add spacing between rows
                                              SizedBox(height: 20),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Morning",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium),
                                                  Text(
                                                      (laborDetail.morning ?? 0)
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Afternoon",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium),
                                                  Text(
                                                      (laborDetail.afternoon ??
                                                              0)
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Overtime",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium),
                                                  Text(
                                                      (laborDetail.overtime ??
                                                              0)
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Materials",
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
                        itemCount: materialDetails.length,
                        itemBuilder: (context, index) {
                          final materialDetail = materialDetails[index];
                          return DailySiteDataTaskItem(
                            id: "",
                            taskId: "",
                            title:
                                // '${materialDetail?.productVariant?.variant} - ${materialDetail?.productVariant?.product?.name}',
                                '${materialDetail.productVariant?.variant}',
                            subtitle:
                                'Quantity Used: ${materialDetail.quantityUsed} (${materialDetail.quantityWasted})',
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
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Table(
                                          columnWidths: const {
                                            0: FlexColumnWidth(),
                                            1: FlexColumnWidth(),
                                          },
                                          children: [
                                            // First row: Material and Unit
                                            TableRow(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Material",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium),
                                                    Text(
                                                        materialDetail
                                                                .productVariant
                                                                ?.variant ??
                                                            "N/A",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Unit",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium),
                                                    Text(
                                                        (materialDetail
                                                                    .productVariant
                                                                    ?.unitOfMeasure
                                                                    ?.name ??
                                                                "N/A")
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const TableRow(
                                              children: [
                                                SizedBox(
                                                    height:
                                                        20), // Add spacing between rows
                                                SizedBox(height: 20),
                                              ],
                                            ),
                                            // Second row: Quantity Used and Quantity Wasted
                                            TableRow(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Quantity Used",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium),
                                                    Text(
                                                        (materialDetail
                                                                    .quantityUsed ??
                                                                0)
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Quantity Wasted",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium),
                                                    Text(
                                                        (materialDetail
                                                                    .quantityWasted ??
                                                                0)
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // const SizedBox(height: 10),
                                      ),
                                    ])
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
    );
  }
}
