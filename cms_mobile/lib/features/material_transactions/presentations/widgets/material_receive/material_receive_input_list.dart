import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/create_material_receive_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialReceiveInputList extends StatelessWidget {
  final List<MaterialReceiveMaterialEntity> materialReceives;
  const MaterialReceiveInputList({super.key, required this.materialReceives});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: materialReceives.length,
      itemBuilder: (context, index) {
        final materialReceive = materialReceives[index];
        final productVariant = materialReceive.material?.productVariant;
        return MaterialTransactionMaterialItem(
          title:
              '${productVariant?.product?.name} - ${productVariant?.variant}',
          subtitle:
              'Amount: ${materialReceive.material?.quantity} ${unitOfMeasureDisplay(materialReceive.material?.productVariant?.unitOfMeasure)}',
          iconSrc: productVariant?.product?.iconSrc,
          onDelete: () => BlocProvider.of<MaterialReceiveLocalBloc>(context)
              .add(DeleteMaterialReceiveMaterialLocal(index)),
          onEdit: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<MaterialReceiveFormCubit>(
                    create: (_) => MaterialReceiveFormCubit(
                      purchaseOrderId: materialReceive.purchaseOrderId,
                      materialId: materialReceive.material?.productVariant?.id,
                      transportationCost: materialReceive.transportationCost,
                      loadingCost: materialReceive.loadingCost,
                      unloadingCost: materialReceive.unloadingCost,
                      remark: materialReceive.remark,
                      
                    ),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child:
                          CreateMaterialReceiveForm(isEdit: true, index: index),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }
}
