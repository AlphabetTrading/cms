import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/home/data/data_source/dashboard/dashboard_remote_data_source.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_expense_stats/detailed_expense_stats_bloc.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_expense_stats/detailed_expense_stats_event.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_expense_stats/detailed_expense_stats_state.dart';
import 'package:cms_mobile/features/home/presentation/widgets/detailed_expense_stat_summary.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailedExpenseStatsPage extends StatefulWidget {
  @override
  _DetailedExpenseStatsPageState createState() =>
      _DetailedExpenseStatsPageState();
}

class _DetailedExpenseStatsPageState extends State<DetailedExpenseStatsPage> {
  String selectedPeriod = 'week';
  String? selectedMaterial;

  FilterExpenseInput filterExpenseInput =
      FilterExpenseInput(filterPeriod: 'week');

  @override
  void initState() {
    super.initState();
    // Fetch materials when the widget is initialized
    BlocProvider.of<ProductBloc>(context)
        .add(const GetAllWarehouseProducts(""));
    BlocProvider.of<DetailedExpenseStatsBloc>(context).add(
        GetDetailedExpenseStatsEvent(filterExpenseInput: filterExpenseInput));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is AllWarehouseProductsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AllWarehouseProductsSuccess) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                              child: CustomDropdown(
                                onSelected: (dynamic value) {
                                  setState(() {
                                    selectedMaterial = value;
                                    filterExpenseInput = filterExpenseInput
                                        .copyWith(productVariantId: value);
                                  });
                                  context.read<DetailedExpenseStatsBloc>().add(
                                        GetDetailedExpenseStatsEvent(
                                          filterExpenseInput:
                                              filterExpenseInput,
                                        ),
                                      );
                                },
                                dropdownMenuEntries: state.allWarehouseProducts
                                        ?.map((e) => DropdownMenuEntry<String>(
                                            label:
                                                '${e.productVariant.product!.name} - ${e.productVariant.variant}',
                                            value: e.productVariant.id))
                                        .toList() ??
                                    [],
                                enableFilter: false,
                                label: 'Select Material',
                                trailingIcon: state is WarehouseProductsLoading
                                    ? const CircularProgressIndicator()
                                    : null,
                              ),
                            )),
                            Expanded(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                    child: CustomDropdown(
                                      initialSelection: 'week',
                                      onSelected: (dynamic value) {
                                        setState(() {
                                          selectedPeriod = value!;
                                          filterExpenseInput =
                                              filterExpenseInput.copyWith(
                                                  filterPeriod: value);
                                        });
                                        context
                                            .read<DetailedExpenseStatsBloc>()
                                            .add(
                                              GetDetailedExpenseStatsEvent(
                                                filterExpenseInput:
                                                    filterExpenseInput,
                                              ),
                                            );
                                      },
                                      dropdownMenuEntries: [
                                        'day',
                                        'week',
                                        'month',
                                        'year',
                                        'alltime'
                                      ]
                                          .map((e) => DropdownMenuEntry<String>(
                                              label: e.toUpperCase(), value: e))
                                          .toList(),
                                      enableFilter: false,
                                      label: '',
                                      trailingIcon: state
                                              is WarehouseProductsLoading
                                          ? const CircularProgressIndicator()
                                          : null,
                                    )))
                          ]);
                    } else if (state is AllWarehouseProductsFailed) {
                      return const Text('Error loading materials');
                    }
                    return const SizedBox();
                  },
                ),
              ))
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<DetailedExpenseStatsBloc, DetailedExpenseStatsState>(
            builder: (context, state) {
              if (state is DetailedExpenseStatsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DetailedExpenseStatsSuccess) {
                final detailedExpenseStats = state.detailedExpenseStats;
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: ShapeDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -5,
                            top: -5,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: ShapeDecoration(
                                color: Colors.white
                                    .withOpacity(0.20000000298023224),
                                shape: const OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -10,
                            top: -20,
                            child: Container(
                              width: 81,
                              height: 81,
                              decoration: ShapeDecoration(
                                color: Colors.white
                                    .withOpacity(0.20000000298023224),
                                shape: const OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            left: MediaQuery.of(context).size.width / 2 - 50,
                            child: Container(
                              width: 33,
                              height: 33,
                              decoration: ShapeDecoration(
                                color: Colors.white
                                    .withOpacity(0.20000000298023224),
                                shape: const OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 80,
                            left: MediaQuery.of(context).size.width - 150,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: const OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            right: MediaQuery.of(context).size.width / 2 - 50,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: const OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 100,
                            left: MediaQuery.of(context).size.width / 3 - 50,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: const OvalBorder(),
                              ),
                            ),
                          ),
                          DetailedExpenseStatSummaryWidget(
                            detailedExpenseStatsEntity: detailedExpenseStats!,
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("Spending History",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Divider(),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: state.detailedExpenseStats!
                                              .spendingHistory!.isNotEmpty
                                          ? SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: state
                                                        .detailedExpenseStats
                                                        ?.spendingHistory
                                                        ?.length,
                                                    itemBuilder: (_, index) {
                                                      final transaction = state
                                                          .detailedExpenseStats
                                                          ?.spendingHistory?[index];
                                                      return _buildSpendingHistoryListItem(
                                                          context, transaction);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                              child: Text(
                                                  'No Transaction History Found')),
                                    ),
                                  ),
                                ],
                              )))
                    ],
                  ),
                );
              } else if (state is DetailedExpenseStatsFailed) {
                return Text('Failed to load expense stats: ${state.error}');
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  _buildSpendingHistoryListItem(
      BuildContext context, SingleSpendingTransactionEntity? transaction) {
    final formatter = NumberFormat('#,##0.00');

    return ListTile(
      title: Text(
          '${transaction?.productVariant?.product!.name} - ${transaction?.productVariant?.variant}'),
      subtitle: Text(transaction?.date != null
          ? DateFormat('MMMM dd, yyyy HH:mm').format(transaction!.date!)
          : 'N/A'),
      trailing: Text('-${formatter.format(transaction?.itemCost)} ETB'),
    );
  }
}
