import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailySiteDataDetailsPage extends StatefulWidget {
  final String dailySiteDataId;
  const DailySiteDataDetailsPage({super.key, required this.dailySiteDataId});
  @override
  State<DailySiteDataDetailsPage> createState() =>
      _DailySiteDataDetailsPageState();
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
    return Scaffold(
      appBar: AppBar(title: const Text("Material Issue Details")),
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
              final preparedBy = dailySiteData?.preparedBy;
              final approvedBy = dailySiteData?.approvedBy;

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
                              title: 'Project',
                              value: approvedBy?.fullName ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Material Issue Number',
                              value:
                                  dailySiteData?.approvedBy?.fullName ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Prepared by',
                              value: preparedBy?.fullName ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Date',
                              value: dailySiteData?.createdAt != null
                                  ? DateFormat('MMMM dd, yyyy HH:mm')
                                      .format(dailySiteData!.createdAt!)
                                  : 'N/A'),
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
