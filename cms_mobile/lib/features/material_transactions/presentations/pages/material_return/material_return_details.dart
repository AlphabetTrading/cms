import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialReturnDetailsPage extends StatefulWidget {
  final String materialReturnId;
  const MaterialReturnDetailsPage({super.key, required this.materialReturnId});
  @override
  State<MaterialReturnDetailsPage> createState() =>
      _MaterialReturnDetailsPageState();
}

class _MaterialReturnDetailsPageState extends State<MaterialReturnDetailsPage> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<MaterialReturnBloc>(context).add(
    //     GetMaterialReturnDetailsEvent(materialReturnId: widget.materialReturnId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Material Return Details")),
      body: BlocProvider<MaterialReturnDetailsCubit>(
        create: (context) => sl<MaterialReturnDetailsCubit>()
          ..onGetMaterialReturnDetails(materialReturnId: widget.materialReturnId),
        child:
            BlocBuilder<MaterialReturnDetailsCubit, MaterialReturnDetailsState>(
          builder: (context, state) {
            if (state is MaterialReturnDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MaterialReturnDetailsFailed) {
              return Text(state.error);
            } else if (state is MaterialReturnDetailsSuccess) {
              final materialReturn = state.materialReturn;
              // final project = materialReturn?.;
              final returnedBy = materialReturn?.returnedBy;
              final receivedBy = materialReturn?.receivedBy;
              final materialReturnMaterials = materialReturn?.items ?? [];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Return Info",
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
                          // TransactionInfoItem(
                          //     title: 'Project', value: project?.name ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Material Return Number',
                              value: materialReturn?.serialNumber ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Returned by',
                              value: returnedBy?.fullName ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Date',
                              value: materialReturn?.createdAt != null
                                  ? DateFormat('MMMM dd, yyyy HH:mm')
                                      .format(materialReturn!.createdAt!)
                                  : 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Status',
                              value: materialReturn?.status?.name ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Received by',
                              value: receivedBy?.fullName ?? 'N/A'),
                                        const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Receiving Warehouse',
                              value:materialReturn?.receivingWarehouseStore?.name ?? 'N/A'),
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
                        itemCount: materialReturnMaterials.length,
                        itemBuilder: (context, index) {
                          final materialReturnMaterial =
                              materialReturnMaterials[index];
                          final productVariant =
                              materialReturnMaterial.productVariant;
                          return MaterialTransactionMaterialItem(
                   
                            title:
                                '${productVariant?.product?.name} - ${productVariant?.variant}',
                            subtitle:
                                'Returned Quantity: ${materialReturnMaterial.quantityReturned} ${unitOfMeasureDisplay(productVariant?.unitOfMeasure)}',
                            iconSrc:
                                'assets/icons/transactions/light/material_return.svg',
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
                                            title: "Returned Quantity",
                                            value:
                                                '${materialReturnMaterial.quantityReturned} ${unitOfMeasureDisplay(productVariant?.unitOfMeasure) }'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Unit Cost",
                                            value:
                                                '${materialReturnMaterial.unitCost.toString()} ETB'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Total Cost",
                                            value:
                                                '${materialReturnMaterial.totalCost.toString()} ETB'),
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
