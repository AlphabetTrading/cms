import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/purchase_order/create_material_issue_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOrderInputList extends StatelessWidget {
  final List<PurchaseOrderMaterialEntity> purchaseOrders;
  const PurchaseOrderInputList({
    super.key,
    required this.purchaseOrders,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: purchaseOrders.length,
      itemBuilder: (context, index) {
        final purchaseOrder = purchaseOrders[index];
        final productVariant = purchaseOrder.material!.productVariant;
        return MaterialTransactionMaterialItem(
          title: '${productVariant.product!.name} - ${productVariant.variant}',
          subtitle:
              'Amount: ${purchaseOrder.quantity} ${purchaseOrder.material!.productVariant.unitOfMeasure}',
          iconSrc: productVariant.product?.iconSrc,
          onDelete: () => BlocProvider.of<PurchaseOrderLocalBloc>(context)
              .add(DeletePurchaseOrderMaterialLocal(index)),
          onEdit: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<PurchaseOrderFormCubit>(
                    create: (_) => PurchaseOrderFormCubit(
                      materialId: purchaseOrder.material!.productVariant.id,
                      quantity: purchaseOrder.quantity,
                      remark: purchaseOrder.remark,
                      subUseDescription: purchaseOrder.subStructureDescription,
                      superUseDescription:
                          purchaseOrder.superStructureDescription,
                      useType: purchaseOrder.useType,
                      inStock: purchaseOrder.material!.quantity,
                    ),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child:
                          CreatePurchaseOrderForm(isEdit: true, index: index),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }
}
