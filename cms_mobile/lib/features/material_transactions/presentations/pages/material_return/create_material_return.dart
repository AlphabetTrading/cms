import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/utils/ids.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_return_form/material_return_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_return_form/material_return_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_return/create_material_return_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_return/material_return_input_list.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class CreateMaterialReturnPage extends StatefulWidget {
  const CreateMaterialReturnPage({super.key});

  @override
  State<CreateMaterialReturnPage> createState() =>
      _CreateMaterialReturnPageState();
}

class _CreateMaterialReturnPageState extends State<CreateMaterialReturnPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  _buildOnCreateSuccess(BuildContext context) {
    context.goNamed(RouteNames.materialReturn);
    BlocProvider.of<MaterialReturnLocalBloc>(context)
        .add(const ClearMaterialReturnMaterialsLocal());
    Fluttertoast.showToast(
        msg: "Material Return Created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _buildOnCreateFailed(BuildContext context) {
    Fluttertoast.showToast(
        msg: "Create Material Return Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    // final materialReturnFormCubit = context.watch<MaterialReturnFormCubit>();
    // final warehouseDropdown = materialReturnFormCubit.state.warehouseDropdown;
    return BlocProvider(
      create: (context) => MaterialReturnWarehouseFormCubit(),
      child: BlocBuilder<MaterialReturnLocalBloc, MaterialReturnLocalState>(
        builder: (localContext, localState) {
          return BlocBuilder<MaterialReturnWarehouseFormCubit,
                  MaterialReturnWarehouseFormState>(
              builder: (warehouseFormContext, warehouseFormState) {
            return BlocConsumer<MaterialReturnBloc, MaterialReturnState>(
              listener: (returnContext, returnState) {
                if (returnState is CreateMaterialReturnSuccess) {
                  _buildOnCreateSuccess(returnContext);
                } else if (returnState is CreateMaterialReturnFailed) {
                  _buildOnCreateFailed(returnContext);
                }
              },
              builder: (returnContext, returnState) {
                 final warehouseForm = warehouseFormContext
                                .watch<MaterialReturnWarehouseFormCubit>();
                return Scaffold(
                    appBar: AppBar(title: const Text("Create Material Return")),
                    bottomSheet: _buildButtons(returnContext, localState,
                        returnState, warehouseForm),
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
                                      warehouseForm.warehouseChanged(value);
                                    },
                                    dropdownMenuEntries: warehouseState
                                            .warehouses
                                            ?.map((e) => DropdownMenuEntry<
                                                    WarehouseEntity>(
                                                label: e.name, value: e))
                                            .toList() ??
                                        [],
                                    enableFilter: false,
                                    errorMessage: warehouseForm
                                        .state.warehouseDropdown.errorMessage,
                                    label: 'To Warehouse',
                                    trailingIcon:
                                        warehouseState is WarehousesLoading
                                            ? const CircularProgressIndicator()
                                            : null,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  (localState.materialReturnMaterials == null ||
                                          localState
                                              .materialReturnMaterials!.isEmpty)
                                      ? const EmptyList()
                                      : MaterialReturnInputList(
                                          materialReturns: localState
                                              .materialReturnMaterials!),
                                ],
                              ),
                            );
                          },
                        )));
              },
            );
          });
        },
      ),
    );
  }

  _buildButtons(
    BuildContext context,
    MaterialReturnLocalState localState,
    MaterialReturnState state,
    MaterialReturnWarehouseFormCubit warehouseForm
  ) {
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
                  BlocProvider<MaterialReturnFormCubit>(
                    create: (_) => MaterialReturnFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CreateMaterialReturnForm(),
                    )
                  ],
                )),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Add Material'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: (state is CreateMaterialReturnLoading ||
                  localState.materialReturnMaterials == null ||
                  localState.materialReturnMaterials!.isEmpty)
              ? null
              : () {
                   warehouseForm.onSubmit();
                  if (warehouseForm.state.isValid) {
                    context.read<MaterialReturnBloc>().add(
                          CreateMaterialReturnEvent(
                            createMaterialReturnParamsEntity:
                                CreateMaterialReturnParamsEntity(
                              projectId: context
                                      .read<ProjectBloc>()
                                      .state
                                      .selectedProjectId ??
                                  "",
                              receivingStoreId:
                                  warehouseForm.state.warehouseDropdown.value,
                              returnedById: USER_ID,
                              // warehouseStoreId: "",

                              materialReturnMaterials:
                                  localState.materialReturnMaterials!
                                      .map((e) => MaterialReturnMaterialEntity(
                                            issueVoucherId: e.issueVoucherId,
                                            quantity: e.quantity,
                                            remark: e.remark,
                                            material: e.material,
                                          ))
                                      .toList(),
                            ),
                          ),
                        );
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

enum WarehouseDropdownError { invalid }

class WarehouseDropdown extends FormzInput<String, WarehouseDropdownError> {
  const WarehouseDropdown.pure([String value = '']) : super.pure(value);
  const WarehouseDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == WarehouseDropdownError.invalid) {
      return 'Select a warehouse to return the materials';
    }
    return null;
  }

  @override
  WarehouseDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return WarehouseDropdownError.invalid;
    }
    return null;
  }
}
