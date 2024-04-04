import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_request_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/create_material_request_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CreateMaterialRequestPage extends StatelessWidget {
  const CreateMaterialRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<MaterialRequestLocalBloc, MaterialRequestLocalState>(
              builder: (context, state) {
                if (state.materialRequestMaterials == null ||
                    state.materialRequestMaterials!.isEmpty) {
                  return const EmptyList();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.materialRequestMaterials?.length ?? 0,
                  itemBuilder: (context, index) {
                    final materialRequest =
                        state.materialRequestMaterials![index];
                    return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: ShapeDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: MaterialTransactionMaterialItem(
                            title: materialRequest.material.name,
                            subtitle: 'Requested Amount: ${materialRequest.requestedQuantity} ${materialRequest.unit}',
                            iconSrc: materialRequest.material.iconSrc,
                            onDelete: () => BlocProvider.of<MaterialRequestLocalBloc>(
                                    context)
                                .add(DeleteMaterialRequestMaterialLocal(index)),
                            onEdit: ()=>showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    BlocProvider<MaterialRequestFormCubit>(
                                  create: (_) => MaterialRequestFormCubit(
                                    materialId: materialRequest.material.id,
                                    requestedQuantity:
                                        materialRequest.requestedQuantity,
                                    unit: materialRequest.unit,
                                    remark: materialRequest.remark,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: Wrap(children: [
                                      CreateMaterialRequestForm(
                                          isEdit: true, index: index),
                                    ]),
                                  ),
                                ),
                              ),),);
                  },
                );
              },
            ),
            Column(children: [
              OutlinedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => BlocProvider<MaterialRequestFormCubit>(
                    create: (_) => MaterialRequestFormCubit(),
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Wrap(children: [CreateMaterialRequestForm()]),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Create Request'),
              )
            ])
          ],
        ),
      ),
    );
  }
}
