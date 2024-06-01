import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialRequestDetailsPage extends StatefulWidget {
  final String materialRequestId;

  const MaterialRequestDetailsPage(
      {super.key, required this.materialRequestId});

  @override
  State<MaterialRequestDetailsPage> createState() =>
      _MaterialRequestDetailsPageState();
}

class _MaterialRequestDetailsPageState
    extends State<MaterialRequestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Material Request Details")),
      body: BlocProvider<MaterialRequestDetailsCubit>(
        create: (context) => sl<MaterialRequestDetailsCubit>()
          ..onGetMaterialRequestDetails(
              materialRequestId: widget.materialRequestId),
        child: BlocBuilder<MaterialRequestDetailsCubit,
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
                                title: 'Material Request Number',
                                value: materialRequest?.serialNumber ?? 'N/A'),
                            SizedBox(height: 12),
                            TransactionInfoItem(
                                title: 'Date',
                                value: materialRequest?.createdAt != null
                                    ? DateFormat('MMMM dd, yyyy HH:mm')
                                        .format(materialRequest!.createdAt!)
                                    : 'N/A'),
                            SizedBox(height: 12),
                            TransactionInfoItem(
                                title: 'Status',
                                value: materialRequest?.status?.name ?? 'N/A'),
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
                                  'assets/icons/transactions/light/material_Requests.svg',
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
