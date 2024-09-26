// boilerplate

import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_proformas/material_proforma_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/approval_status.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/edit/edit_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_proforma/material_proforma_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

  String selectedMaterialProformaItemId = "";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MaterialProformaDetailsCubit>()
            ..onGetMaterialProformaDetails(
                materialProformaId: widget.materialProformaId),
        ),
        BlocProvider(create: (context) => sl<EditMaterialProformaCubit>())
      ],
      child: BlocConsumer<EditMaterialProformaCubit, EditMaterialProformaState>(
        listener: (context, editState) {
          if (editState is EditMaterialProformaSuccess) {
            // Show success message
            showStatusMessage(
                Status.SUCCESS, "Material Proforma updated successfully");
            // Refresh the page
            context.read<MaterialProformaBloc>().add(GetMaterialProformas(
                  filterMaterialProformaInput: FilterMaterialProformaInput(),
                  orderBy: OrderByMaterialProformaInput(createdAt: "desc"),
                  paginationInput: PaginationInput(skip: 0, take: 20),
                ));
            context.pop();
          } else if (editState is EditMaterialProformaFailed) {
            // Show error message
            showStatusMessage(Status.FAILED, editState.error);
          }
        },
        builder: (context, editState) {
          return Scaffold(
            bottomSheet: BlocBuilder<MaterialProformaDetailsCubit,
                MaterialProformaDetailsState>(
              builder: (context, state) {
                if (state is MaterialProformaDetailsSuccess &&
                    state.materialProforma?.status ==
                        ApprovalStatus.PENDING.name) {
                  return _buildApproveDeclineSection(
                      context, widget.materialProformaId, editState);
                }
                return const SizedBox();
              },
            ),
            appBar: AppBar(title: const Text("Material Proforma Details")),
            body: BlocBuilder<MaterialProformaDetailsCubit,
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
                  final materialRequestItem =
                      materialProforma?.materialRequestItem;

                  if (selectedMaterialProformaItemId == "") {
                    selectedMaterialProformaItemId =
                        materialProforma?.selectedProformaItem?.id ?? "";
                  }

                  // selectedMaterialProformaItemId =
                  //     materialProforma?.selectedProformaItem?.id ?? "";

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
                              horizontal: 16, vertical: 16),
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
                              const SizedBox(height: 12),
                              TransactionInfoItem(
                                  title: 'Material Proforma Number',
                                  value:
                                      materialProforma?.serialNumber ?? 'N/A'),
                              const SizedBox(height: 12),
                              TransactionInfoItem(
                                  title: 'Requested Material',
                                  value:
                                      '${materialRequestItem?.productVariant?.variant} - ${materialRequestItem?.productVariant?.product?.name}'),
                              const SizedBox(height: 12),
                              TransactionInfoItem(
                                  title: 'Requested Quantity',
                                  value: '${materialRequestItem?.quantity}'),
                              const SizedBox(height: 12),
                              TransactionInfoItem(
                                  title: 'Unit of measure',
                                  value: unitOfMeasureDisplay(
                                      materialRequestItem
                                          ?.productVariant?.unitOfMeasure)),
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
                            itemCount: proformaItems?.length,
                            itemBuilder: (context, index) {
                              final proformaItem = proformaItems?[index];
                              // final ven = proformaItem?.vendor;

                              return Container(
                                height: 80,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: ShapeDecoration(
                                  color: const Color(0x110F4A84),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: ListTile(
                                  leading: Radio(
                                    
                                    value: proformaItem!.id,
                                    groupValue: selectedMaterialProformaItemId,
                                    onChanged: materialProforma?.status ==
                        ApprovalStatus.PENDING.name?(value) {
                                      setState(() {
                                        selectedMaterialProformaItemId =
                                            value.toString();
                                      });
                                    }:null,
                                  ),
                                  title: Text(proformaItem?.vendor ?? 'N/A'),
                                  subtitle: Text(
                                    'Quantity: ${proformaItem?.quantity}',
                                  ),
                                  trailing: TextButton(
                                    onPressed: () {
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
                                                        proformaItem?.vendor ??
                                                            'N/A'),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ProductDetail(
                                                    title: "Quantity",
                                                    value: proformaItem
                                                            ?.quantity
                                                            .toString() ??
                                                        'N/A'),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ProductDetail(
                                                    title: "Unit Price",
                                                    value: proformaItem
                                                            ?.unitPrice
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
                                                        proformaItem?.remark ??
                                                            'N/A'),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                proformaItem != null &&
                                                        proformaItem
                                                            .photos.isNotEmpty
                                                    ? SizedBox(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HeroPhotoViewRouteWrapper(
                                                                  imageProvider:
                                                                      NetworkImage(
                                                                    proformaItem
                                                                        .photos[0],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Hero(
                                                            tag: "someTag",
                                                            child:
                                                                Image.network(
                                                              proformaItem
                                                                  .photos[0],
                                                              width: 300.0,
                                                              height: 200.0,
                                                              loadingBuilder: (_,
                                                                      child,
                                                                      chunk) =>
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
                                    child: const Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: Color(0xFF1A80E5),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 0.17,
                                      ),
                                    ),
                                  ),
                                ),
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
          );
        },
      ),
    );
  }

  _buildApproveDeclineSection(BuildContext context, materialProformaId,
      EditMaterialProformaState state) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: state is EditMaterialProformaLoading
                ? null
                : () {
                    BlocProvider.of<EditMaterialProformaCubit>(context)
                        .onApproveMaterialProforma(
                            params: ApproveMaterialProformaParamsEntity(
                                proformaId: materialProformaId,
                                selectedProformaItemId:
                                    selectedMaterialProformaItemId));
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state is EditMaterialProformaLoading
                    ? const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            )),
                      )
                    : const SizedBox(),
                const Text('Approve'),
              ],
            ),
          ),
        ],
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
