import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_return_form/material_return_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_return/create_material_return_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialReturnInputList extends StatelessWidget {
  final List<MaterialReturnMaterialEntity> materialReturns;
  const MaterialReturnInputList({super.key, required this.materialReturns});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: materialReturns.length,
      itemBuilder: (context, index) {
        final materialReturn = materialReturns[index];
        final productVariant = materialReturn.material?.productVariant;
        return MaterialTransactionMaterialItem(
          title:
              '${productVariant?.product?.name} - ${productVariant?.variant}',
          subtitle:
              'Amount: ${materialReturn.quantity} ${unitOfMeasureDisplay(materialReturn.material?.productVariant?.unitOfMeasure)}',
          iconSrc: productVariant?.product?.iconSrc,
          onDelete: () => BlocProvider.of<MaterialReturnLocalBloc>(context)
              .add(DeleteMaterialReturnMaterialLocal(index)),
          onEdit: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<MaterialReturnFormCubit>(
                    create: (_) => MaterialReturnFormCubit(
                      materialId: materialReturn.material?.productVariant?.id,
                      quantity: materialReturn.quantity,
                      remark: materialReturn.remark,
                      issuedQuantity: materialReturn.material?.quantity,
                      materialIssueId: materialReturn.issueVoucherId,
                      
                    ),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child:
                          CreateMaterialReturnForm(isEdit: true, index: index),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }
}
