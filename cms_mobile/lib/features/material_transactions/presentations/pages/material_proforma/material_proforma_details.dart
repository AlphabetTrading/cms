// boilerplate

import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

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
      appBar: AppBar(title: const Text("Material Proforma Details")),
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
              final proformaItems = materialProforma?.items;
              final materialRequestItem = materialProforma?.materialRequestItem;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Proforma Info",
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
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Material Proforma Number',
                              value: materialProforma?.serialNumber ?? 'N/A'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Requested Material',
                              value: '${materialRequestItem?.productVariant?.variant} - ${materialRequestItem?.productVariant?.product?.name}'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Requested Quantity',
                              value: '${materialRequestItem?.quantity}'),
                          const SizedBox(height: 12),
                          TransactionInfoItem(
                              title: 'Unit of measure',
                              value: unitOfMeasureDisplay(materialRequestItem?.productVariant?.unitOfMeasure)),
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
                          "Proformas List",
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
                        itemCount: proformaItems?.length,
                        itemBuilder: (context, index) {
                          final proformaItem = proformaItems?[index];
                          // final ven = proformaItem?.vendor;

                          return MaterialTransactionMaterialItem(
                            title: proformaItem?.vendor ?? 'N/A',
                            subtitle: 'Quantity: ${proformaItem?.quantity}',
                            iconSrc:
                                'assets/icons/transactions/light/material_issues.svg',
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
                                            title: "Vendor",
                                            value:
                                                proformaItem?.vendor ?? 'N/A'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Quantity",
                                            value: proformaItem?.quantity
                                                    .toString() ??
                                                'N/A'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Unit Price",
                                            value: proformaItem?.unitPrice
                                                    .toString() ??
                                                'N/A'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Total Price",
                                            value:
                                                '${proformaItem?.unitPrice.toString() ?? 'N/A'} ETB'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ProductDetail(
                                            title: "Remark",
                                            value:
                                                proformaItem?.remark ?? 'N/A'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        proformaItem != null &&
                                                proformaItem.photos.isNotEmpty
                                            ? SizedBox(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                             HeroPhotoViewRouteWrapper(
                                                          imageProvider:
                                                              NetworkImage(
                                                            proformaItem.photos[0],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Hero(
                                                    tag: "someTag",
                                                    child: Image.network(
                                                     proformaItem.photos[0],
                                                      width: 300.0,
                                                      height: 200.0,
                                                      loadingBuilder:
                                                          (_, child, chunk) =>
                                                              chunk != null
                                                                  ? const CircularProgressIndicator()
                                                                  : child,
                                                    ),
                                                  ),
                                                ),
                                              )
                            
                                            : const SizedBox(),
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

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
