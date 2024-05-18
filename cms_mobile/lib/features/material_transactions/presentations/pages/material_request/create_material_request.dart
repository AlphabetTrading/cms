import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_request_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/create_material_request_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class CreateMaterialRequestPage extends StatelessWidget {
  const CreateMaterialRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<MaterialRequestBloc, MaterialRequestState>(
          listener: (context, state) {
            if (state is CreateMaterialRequestSuccess) {
              context.goNamed(RouteNames.materialRequest);
               BlocProvider.of<MaterialRequestLocalBloc>(
                                            context).add(const ClearMaterialRequestMaterialsLocal());
              Fluttertoast.showToast(
                  msg: "Material Request Created",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Color.fromARGB(255, 1, 135, 23),
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (state is CreateMaterialRequestFailed) {
              Fluttertoast.showToast(
                  msg: "Create Material Request Failed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          builder: (context, state) {
            return BlocBuilder<MaterialRequestLocalBloc,
                MaterialRequestLocalState>(
              builder: (localContext, localState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (localState.materialRequestMaterials == null ||
                            localState.materialRequestMaterials!.isEmpty)
                        ? const EmptyList()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                localState.materialRequestMaterials?.length ??
                                    0,
                            itemBuilder: (context, index) {
                              final materialRequest =
                                  localState.materialRequestMaterials![index];
                              final itemVariant =
                                  materialRequest.material!.itemVariant;
                              return MaterialTransactionMaterialItem(
                                title:
                                    '${itemVariant.item!.name} - ${itemVariant.variant}',
                                subtitle:
                                    'Requested Amount: ${materialRequest.requestedQuantity} ${materialRequest.material!.itemVariant.unit}',
                                iconSrc: itemVariant.item?.iconSrc,
                                onDelete: () =>
                                    BlocProvider.of<MaterialRequestLocalBloc>(
                                            context)
                                        .add(DeleteMaterialRequestMaterialLocal(
                                            index)),
                                onEdit: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      BlocProvider<MaterialRequestFormCubit>(
                                    create: (_) => MaterialRequestFormCubit(
                                      materialId: materialRequest
                                          .material!.itemVariant.id,
                                      requestedQuantity:
                                          materialRequest.requestedQuantity,
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
                          builder: (context) =>
                              BlocProvider<MaterialRequestFormCubit>(
                            create: (_) => MaterialRequestFormCubit(),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child:
                                  Wrap(children: [CreateMaterialRequestForm()]),
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
                        onPressed: (state is CreateMaterialRequestLoading ||
                                localState.materialRequestMaterials == null ||
                                localState.materialRequestMaterials!.isEmpty)
                            ? null
                            : () {
                                context.read<MaterialRequestBloc>().add(
                                    CreateMaterialRequestEvent(
                                        createMaterialRequestParamsEntity:
                                            CreateMaterialRequestParamsEntity(
                                                projectId:
                                                    "7e887f9a-4141-426a-83cb-3de082ee1171",
                                                requestedById:
                                                    "0c5b5d84-0da5-409a-b701-fa87c9340868",
                                                materialRequestMaterials: localState
                                                    .materialRequestMaterials!
                                                    .map((e) =>
                                                        MaterialRequestMaterialEntity(
                                                          requestedQuantity: e
                                                              .requestedQuantity,
                                                          material: e.material,
                                                          remark: e.remark,
                                                        ))
                                                    .toList())));
                              },

                        //  (state is CreateMaterialRequestLoading ||
                        //         localState.materialRequestMaterials == null ||
                        //         localState.materialRequestMaterials!.isEmpty)
                        //     ? null
                        //     : () {
                        //         // context.read<AuthBloc>().state.user,

                        //       },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            state is CreateMaterialRequestLoading
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
                            const Text('Create Material Request')
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
