import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/utils/ids.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_return_form/material_return_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/proforma_form/proforma_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/proforma_form/proforma_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_return/create_material_return_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/proforma/proforma_form.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class CreateProformaPage extends StatefulWidget {
  const CreateProformaPage({super.key});

  @override
  State<CreateProformaPage> createState() => _CreateProformaPageState();
}

class _CreateProformaPageState extends State<CreateProformaPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  _buildOnCreateSuccess(BuildContext context) {
    context.goNamed(RouteNames.materialReturn);
    BlocProvider.of<MaterialReturnLocalBloc>(context)
        .add(const ClearMaterialReturnMaterialsLocal());
    showStatusMessage(Status.SUCCESS, "Proforma Created");
  }

  _buildOnCreateFailed(BuildContext context) {
    showStatusMessage(Status.FAILED, "Create Proforma Failed");
  }

  @override
  Widget build(BuildContext context) {
    // final materialReturnFormCubit = context.watch<MaterialReturnFormCubit>();
    // final warehouseDropdown = materialReturnFormCubit.state.warehouseDropdown;
    return BlocProvider(
      create: (context) => ProformaMainFormCubit(),
      child:  BlocBuilder<ProformaMainFormCubit,
                  ProformaMainFormState>(
              builder: (proformaMainFormContext, proformaMainFormState) {
            return BlocConsumer<MaterialReturnBloc, MaterialReturnState>(
              listener: (returnContext, returnState) {
                if (returnState is CreateMaterialReturnSuccess) {
                  _buildOnCreateSuccess(returnContext);
                } else if (returnState is CreateMaterialReturnFailed) {
                  _buildOnCreateFailed(returnContext);
                }
              },
              builder: (returnContext, returnState) {
                final proformaMainFormCubit = proformaMainFormContext.read<ProformaMainFormCubit>();
                final materialRequestDropdown = proformaMainFormState.materialRequestDropdown;
                final materialDropdown = proformaMainFormState.materialDropdown;

                return Scaffold(
                    appBar: AppBar(title: const Text("Create Material Return")),
                    bottomSheet: _buildButtons(
                        returnContext, returnState, proformaMainFormCubit),
                    body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<WarehouseBloc, WarehouseState>(
                          builder: (warehouseContext, warehouseState) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  CustomDropdown(
                                    onSelected: (dynamic value) {
                                      proformaMainFormCubit.materialRequestChanged(value);
                                    },
                                    dropdownMenuEntries: warehouseState
                                            .warehouses
                                            ?.map((e) => DropdownMenuEntry<
                                                    WarehouseEntity>(
                                                label: e.name, value: e))
                                            .toList() ??
                                        [],
                                    enableFilter: false,
                                    errorMessage: materialRequestDropdown.errorMessage,
                                    label: 'Material Request',
                                    trailingIcon:
                                        warehouseState is WarehousesLoading
                                            ? const CircularProgressIndicator()
                                            : null,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomDropdown(
                                    onSelected: (dynamic value) {
                                      proformaMainFormCubit.materialChanged(value);
                                    },
                                    dropdownMenuEntries: warehouseState
                                            .warehouses
                                            ?.map((e) => DropdownMenuEntry<
                                                    WarehouseEntity>(
                                                label: e.name, value: e))
                                            .toList() ??
                                        [],
                                    enableFilter: false,
                                    errorMessage: materialDropdown.errorMessage,
                                    label: 'Material',
                                    trailingIcon:
                                        warehouseState is WarehousesLoading
                                            ? const CircularProgressIndicator()
                                            : null,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // (localState.materialReturnMaterials == null ||
                                  //         localState
                                  //             .materialReturnMaterials!.isEmpty)
                                  //     ? const EmptyList()
                                  //     : MaterialReturnInputList(
                                  //         materialReturns: localState
                                  //             .materialReturnMaterials!),
                                ],
                              ),
                            );
                          },
                        )));
              },
            );
          })
        
      
    );
  }

  _buildButtons(
      BuildContext context,
      MaterialReturnState state,
      ProformaMainFormCubit warehouseForm) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        OutlinedButton(
          // onPressed:(){},
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: warehouseForm,
                  ),
                  BlocProvider<ProformaItemFormCubit>(
                    create: (_) => ProformaItemFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: ProformaFrom(),
                    )
                  ],
                )),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Add Proforma'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: 
          // (
          //   state is CreateMaterialReturnLoading ||
          //         localState.materialReturnMaterials == null ||
          //         localState.materialReturnMaterials!.isEmpty)
          //     ? null
          //     : 
              () {
                  warehouseForm.onSubmit();
                  if (warehouseForm.state.isValid) {
                    // context.read<MaterialReturnBloc>().add(
                    //       CreateMaterialReturnEvent(
                    //         createMaterialReturnParamsEntity:
                    //             CreateMaterialReturnParamsEntity(
                    //           projectId: context
                    //                   .read<ProjectBloc>()
                    //                   .state
                    //                   .selectedProjectId ??
                    //               "",
                    //           receivingStoreId:
                    //               warehouseForm.state.warehouseDropdown.value,
                    //           returnedById: USER_ID,
                    //           // warehouseStoreId: "",

                    //           materialReturnMaterials:
                    //               localState.materialReturnMaterials!
                    //                   .map((e) => MaterialReturnMaterialEntity(
                    //                         issueVoucherId: e.issueVoucherId,
                    //                         quantity: e.quantity,
                    //                         remark: e.remark,
                    //                         material: e.material,
                    //                       ))
                    //                   .toList(),
                    //         ),
                    //       ),
                    //     );
                  }
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is CreateMaterialReturnLoading
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
              const Text('Create Material Return')
            ],
          ),
        )
      ]),
    );
  }
}

enum MaterialRequestDropdownError { invalid }

class MaterialRequestDropdown
    extends FormzInput<String, MaterialRequestDropdownError> {
  const MaterialRequestDropdown.pure([String value = '']) : super.pure(value);
  const MaterialRequestDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MaterialRequestDropdownError.invalid) {
      return 'Select a material request';
    }
    return null;
  }

  @override
  MaterialRequestDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return MaterialRequestDropdownError.invalid;
    }
    return null;
  }
}

enum MaterialDropdownError { invalid }

class MaterialDropdown extends FormzInput<String, MaterialDropdownError> {
  const MaterialDropdown.pure([String value = '']) : super.pure(value);
  const MaterialDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MaterialDropdownError.invalid) {
      return 'Select a material request';
    }
    return null;
  }

  @override
  MaterialDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return MaterialDropdownError.invalid;
    }
    return null;
  }
}
