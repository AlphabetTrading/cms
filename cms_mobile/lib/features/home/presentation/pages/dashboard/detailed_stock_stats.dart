import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/home/data/data_source/dashboard/dashboard_remote_data_source.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_stock_stats/detailed_stock_stats_bloc.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_stock_stats/detailed_stock_stats_event.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_stock_stats/detailed_stock_stats_state.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailedStockStatsPage extends StatefulWidget {
  const DetailedStockStatsPage({super.key});

  @override
  _DetailedStockStatsPageState createState() => _DetailedStockStatsPageState();
}

class _DetailedStockStatsPageState extends State<DetailedStockStatsPage> {
  String selectedPeriod = 'week';
  String? selectedMaterial;

  FilterStockInput filterStockInput = FilterStockInput(filterPeriod: 'week');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context)
        .add(const GetAllWarehouseProducts(""));
    BlocProvider.of<DetailedStockStatsBloc>(context)
        .add(GetDetailedStockStatsEvent(filterStockInput: filterStockInput));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
        child: SingleChildScrollView(
            child: Column(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              double cardWidth = (constraints.maxWidth - (3 * 6)) / 2;

              return BlocBuilder<DetailedStockStatsBloc,
                  DetailedStockStatsState>(
                builder: (context, detailedState) {
                  if (detailedState is DetailedStockStatsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (detailedState is DetailedStockStatsSuccess) {
                    final data = detailedState.detailedStockStats;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Wrap(
                              spacing: 16.0,
                              runSpacing: 16.0,
                              children: [
                                SizedBox(
                                  width: cardWidth,
                                  height: 135,
                                  child: _buildStatCard(
                                    'Total Items Bought',
                                    data?.totalItemBought?.toStringAsFixed(0) ??
                                        '0',
                                    Colors.blue,
                                  ),
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  height: 135,
                                  child: _buildStatCard(
                                    'Total Items Used',
                                    data?.totalItemUsed?.toStringAsFixed(0) ??
                                        '0',
                                    Colors.grey.shade200,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Wrap(
                              spacing: 16.0,
                              runSpacing: 16.0,
                              children: [
                                SizedBox(
                                  width: cardWidth,
                                  height: 135,
                                  child: _buildStatCard(
                                    'Total Items Lost',
                                    data?.totalItemLost?.toStringAsFixed(0) ??
                                        '0',
                                    Colors.grey.shade200,
                                  ),
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  height: 135,
                                  child: _buildStatCard(
                                    'Total Items Wasted',
                                    data?.totalItemWasted?.toStringAsFixed(0) ??
                                        '0',
                                    Colors.grey.shade200,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (detailedState is DetailedStockStatsFailed) {
                    return const Text('Failed to load detailed stock stats.');
                  }
                  return const SizedBox();
                },
              );
            }),
            const SizedBox(height: 20),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                                child: CustomDropdown(
                                  onSelected: (dynamic value) {
                                    setState(() {
                                      selectedMaterial = value;
                                      filterStockInput = filterStockInput
                                          .copyWith(productVariantId: value);
                                    });
                                    context.read<DetailedStockStatsBloc>().add(
                                          GetDetailedStockStatsEvent(
                                            filterStockInput: filterStockInput,
                                          ),
                                        );
                                  },
                                  dropdownMenuEntries: state
                                          .allWarehouseProducts
                                          ?.map((e) => DropdownMenuEntry<
                                                  String>(
                                              label:
                                                  '${e.productVariant.product!.name} - ${e.productVariant.variant}',
                                              value: e.productVariant.id))
                                          .toList() ??
                                      [],
                                  enableFilter: false,
                                  label: 'Select Material',
                                  trailingIcon:
                                      state is WarehouseProductsLoading
                                          ? const CircularProgressIndicator()
                                          : null,
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0, 0, 0),
                                      child: CustomDropdown(
                                        initialSelection: 'week',
                                        onSelected: (dynamic value) {
                                          setState(() {
                                            selectedPeriod = value!;
                                            filterStockInput = filterStockInput
                                                .copyWith(filterPeriod: value);
                                          });
                                          context
                                              .read<DetailedStockStatsBloc>()
                                              .add(
                                                GetDetailedStockStatsEvent(
                                                  filterStockInput:
                                                      filterStockInput,
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
                                            .map((e) =>
                                                DropdownMenuEntry<String>(
                                                    label: e.toUpperCase(),
                                                    value: e))
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
            BlocBuilder<DetailedStockStatsBloc, DetailedStockStatsState>(
              builder: (context, detailedState) {
                if (detailedState is DetailedStockStatsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (detailedState is DetailedStockStatsSuccess) {
                  final data = detailedState.detailedStockStats;
                  if (data?.totalItemLost == 0 &&
                      data?.totalItemUsed == 0 &&
                      data?.totalItemWasted == 0) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("No data available!"),
                    ));
                  }
                  final pieChartData = [
                    // _ChartData('Total Bought', data?.totalItemBought ?? 0),
                    _ChartData('Total Lost', data?.totalItemLost ?? 0),
                    _ChartData('Total Used', data?.totalItemUsed ?? 0),
                    _ChartData('Total Wasted', data?.totalItemWasted ?? 0),
                  ];

                  return SfCircularChart(
                    title: const ChartTitle(text: ''),
                    legend: const Legend(isVisible: true),
                    series: <CircularSeries>[
                      PieSeries<_ChartData, String>(
                        dataSource: pieChartData,
                        xValueMapper: (_ChartData data, _) => data.label,
                        yValueMapper: (_ChartData data, _) => data.value,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  );
                } else if (detailedState is DetailedStockStatsFailed) {
                  return const Text('Failed to load detailed stock stats.');
                }
                return const SizedBox();
              },
            ),
          ],
        )));
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: color,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Wrap(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: color == Colors.blue
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                  ],
                )),
                const SizedBox(
                  width: 5.0,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: ShapeDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: SvgPicture.asset(
                    color == Colors.blue
                        ? 'assets/icons/dashboard/dark/analytics.svg'
                        : 'assets/icons/dashboard/light/analytics.svg',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              count,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color == Colors.blue ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.label, this.value);
  final String label;
  final double value;
}
