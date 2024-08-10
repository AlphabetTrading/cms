// boilerplate


import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialProformaDetailsPage extends StatefulWidget {
  final String materialProformaId;
  const MaterialProformaDetailsPage(
      {super.key, required this.materialProformaId});
  @override
  State<MaterialProformaDetailsPage> createState() =>
      _MaterialProformaDetailsPageState();
}

class _MaterialProformaDetailsPageState
    extends State<MaterialProformaDetailsPage> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<MaterialProformaBloc>(context).add(
    //     GetMaterialProformaDetailsEvent(materialProformaId: widget.materialProformaId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Material Issue Details")),
      body: BlocProvider<MaterialProformaDetailsCubit>(
        create: (context) => sl<MaterialProformaDetailsCubit>()
          ..onGetMaterialProformaDetails(
              materialProformaId: widget.materialProformaId),
        child: BlocBuilder<MaterialProformaDetailsCubit,
            MaterialProformaDetailsState>(
          builder: (context, state) {
            if (state is MaterialProformaDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MaterialProformaDetailsFailed) {
              return Text(state.error);
            } else if (state is MaterialProformaDetailsSuccess) {
              final materialProforma = state.materialProforma;
              final preparedBy = materialProforma?.preparedBy;
              final approvedBy = materialProforma?.approvedBy;

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
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Material Issue Number',
                              value: materialProforma?.serialNumber ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Prepared by',
                              value: preparedBy?.fullName ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Date',
                              value: materialProforma?.createdAt != null
                                  ? DateFormat('MMMM dd, yyyy HH:mm')
                                      .format(materialProforma!.createdAt!)
                                  : 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Status',
                              value: materialProforma?.status ?? 'N/A'),
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
