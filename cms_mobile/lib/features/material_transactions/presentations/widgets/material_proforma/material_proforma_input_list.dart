import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_proforma_form/material_proforma_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_return/create_material_return_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialProformaInputList extends StatelessWidget {
  final List<MaterialProformaMaterialEntity> materialProformaMaterials;
  const MaterialProformaInputList(
      {super.key, required this.materialProformaMaterials});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: materialProformaMaterials.length,
      itemBuilder: (context, index) {
        final materialProformaMaterial = materialProformaMaterials[index];
        // final productVariant = materialProformaMaterial.material?.productVariant;
        return MaterialTransactionMaterialItem(
          title: '${materialProformaMaterial.vendor} ',
          subtitle: 'Total Price: ${materialProformaMaterial.unitPrice * materialProformaMaterial.quantity} ',
          onDelete: () => BlocProvider.of<MaterialReturnLocalBloc>(context)
              .add(DeleteMaterialReturnMaterialLocal(index)),
          onEdit: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<MaterialProformaItemFormCubit>(
                    create: (_) => MaterialProformaItemFormCubit(
                      vendor: materialProformaMaterial.vendor,
                      price: materialProformaMaterial.unitPrice,
                      remark: materialProformaMaterial.remark,
                      photo: materialProformaMaterial.photo,
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
