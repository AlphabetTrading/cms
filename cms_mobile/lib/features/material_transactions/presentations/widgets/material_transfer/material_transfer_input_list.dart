import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_transfer_form/material_transfer_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transfer/create_material_transfer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialTransferInputList extends StatelessWidget {
  final List<MaterialTransferEntity> materialTransfers;
  const MaterialTransferInputList({
    super.key,
    required this.materialTransfers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: materialTransfers.length,
      itemBuilder: (context, index) {
        final materialTransfer = materialTransfers[index];
        final productVariant = materialTransfer.approvedById;
        return SizedBox.shrink();
        // return MaterialTransactionMaterialItem(
        //   title: '${productVariant.product!.name} - ${productVariant.variant}',
        //   subtitle:
        //       'Amount: ${materialTransfer.materialGroup} ${materialTransfer.preparedById}',
        //   iconSrc: productVariant.product?.iconSrc,
        //   onDelete: () => BlocProvider.of<MaterialTransferLocalBloc>(context)
        //       .add(DeleteMaterialTransferMaterialLocal(index)),
        //   onEdit: () => showModalBottomSheet(
        //     isScrollControlled: true,
        //     context: context,
        //     builder: (context) => MultiBlocProvider(
        //         providers: [
        //           // BlocProvider<MaterialTransferFormCubit>(
        //           //   create: (_) => MaterialTransferFormCubit(
        //           //     materialId: materialTransfer.material!.productVariant.id,
        //           //     quantity: materialTransfer.quantity,
        //           //     remark: materialTransfer.remark,
        //           //     subUseDescription: materialTransfer.subStructureDescription,
        //           //     superUseDescription:
        //           //         materialTransfer.superStructureDescription,
        //           //     useType: materialTransfer.useType,
        //           //     inStock: materialTransfer.material!.quantity,
        //           //   ),
        //           // )

        //         ],
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.all(32.0),
        //               child:
        //                   CreateMaterialTransferForm(isEdit: true, index: index),
        //             )
        //           ],
        //         )),
        //   ),
        // );
      },
    );
  }
}
