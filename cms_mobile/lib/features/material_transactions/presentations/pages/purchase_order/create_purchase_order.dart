import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/utils/ids.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/purchase_order/create_purchase_order_form.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePurchaseOrderPage extends StatelessWidget {
  const CreatePurchaseOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Purchase Order")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<PurchaseOrderBloc, PurchaseOrderState>(
          listener: (context, state) {
            if (state is CreatePurchaseOrderSuccess) {
              context.goNamed(RouteNames.purchaseOrders);
              BlocProvider.of<PurchaseOrderLocalBloc>(context)
                  .add(const ClearPurchaseOrderMaterialsLocal());
              BlocProvider.of<PurchaseOrderBloc>(context).add(
                GetPurchaseOrdersEvent(
                    filterPurchaseOrderInput: FilterPurchaseOrderInput(),
                    orderBy: OrderByPurchaseOrderInput(createdAt: "desc"),
                    paginationInput: PaginationInput(skip: 0, take: 20),
                    mine: false),
              );
              showStatusMessage(Status.SUCCESS, "Purchase Order Created");
            } else if (state is CreatePurchaseOrderFailed) {
              showStatusMessage(
                  Status.FAILED, "Unable to Create Purchase Order");
            }
          },
          builder: (context, state) {
            return BlocBuilder<PurchaseOrderLocalBloc, PurchaseOrderLocalState>(
              builder: (localContext, localState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (localState.purchaseOrderMaterials == null ||
                            localState.purchaseOrderMaterials!.isEmpty)
                        ? const EmptyList()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                localState.purchaseOrderMaterials?.length ?? 0,
                            itemBuilder: (context, index) {
                              final purchaseOrder =
                                  localState.purchaseOrderMaterials![index];
                              final productVariant = purchaseOrder
                                      .materialRequestItem?.productVariant ??
                                  purchaseOrder.proforma?.materialRequestItem
                                      ?.productVariant;
                              return MaterialTransactionMaterialItem(
                                title:
                                    '${productVariant?.product!.name} - ${productVariant?.variant}',
                                subtitle:
                                    'Quantity: ${purchaseOrder.quantity} ${productVariant?.unitOfMeasure?.name}',
                                iconSrc: productVariant?.product?.iconSrc,
                                onDelete: () =>
                                    BlocProvider.of<PurchaseOrderLocalBloc>(
                                            context)
                                        .add(DeletePurchaseOrderMaterialLocal(
                                            index)),
                                onEdit: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      BlocProvider<PurchaseOrderFormCubit>(
                                    create: (_) => PurchaseOrderFormCubit(
                                      // materialId: purchaseOrder
                                      //     .material!.productVariant.id,
                                      materialRequestItemId:
                                          purchaseOrder.materialRequestItemId,
                                      proformaId: purchaseOrder.proformaId,
                                      unitPrice: purchaseOrder.unitPrice,
                                      totalPrice: purchaseOrder.totalPrice,
                                      quantity: purchaseOrder.quantity,
                                      remark: purchaseOrder.remark,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(32.0),
                                      child: Wrap(children: [
                                        CreatePurchaseOrderForm(
                                            isEdit: true, index: index),
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    Column(children: [
                      OutlinedButton(
                        // onPressed: () {
                        // },
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) =>
                              BlocProvider<PurchaseOrderFormCubit>(
                            create: (_) => PurchaseOrderFormCubit(),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child:
                                  Wrap(children: [CreatePurchaseOrderForm()]),
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Add Material'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: (state is CreatePurchaseOrderLoading ||
                                localState.purchaseOrderMaterials == null ||
                                localState.purchaseOrderMaterials!.isEmpty)
                            ? null
                            : () {
                                bool isProforma = true;
                                final materials =
                                    localState.purchaseOrderMaterials!.map((e) {
                                  isProforma = e.isProforma!;
                                  return PurchaseOrderMaterialEntity(
                                    isProforma: e.isProforma,
                                    quantity: e.quantity,
                                    unitPrice: e.unitPrice,
                                    totalPrice: e.totalPrice,
                                    remark: e.remark ?? "",
                                    materialRequestItemId:
                                        e.materialRequestItemId,
                                    proformaId: e.proformaId,
                                  );
                                }).toList();
                                context.read<PurchaseOrderBloc>().add(
                                    CreatePurchaseOrderEvent(
                                        createPurchaseOrderParamsEntity:
                                            CreatePurchaseOrderParamsEntity(
                                                isProforma: isProforma,
                                                projectId: context
                                                        .read<ProjectBloc>()
                                                        .state
                                                        .selectedProjectId ??
                                                    "",
                                                preparedById: context
                                                        .read<AuthBloc>()
                                                        .state
                                                        .user
                                                        ?.id ??
                                                    USER_ID,
                                                purchaseOrderMaterials:
                                                    materials)));
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            state is CreatePurchaseOrderLoading
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
                            const Text('Create Purchase Order')
                          ],
                        ),
                      )
                    ])
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
