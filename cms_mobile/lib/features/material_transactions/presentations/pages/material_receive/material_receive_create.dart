import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/utils/ids.dart';

import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/create_material_receive_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/material_receive_input_list.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class MaterialReceiveCreatePage extends StatefulWidget {
  const MaterialReceiveCreatePage({super.key});

  @override
  State<MaterialReceiveCreatePage> createState() =>
      _MaterialReceiveCreatePageState();
}

class _MaterialReceiveCreatePageState extends State<MaterialReceiveCreatePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  // final String savedUserId = await GQLClient.getUserIdFromStorage();

  _buildOnCreateSuccess(BuildContext context) {
    // context.goNamed(RouteNames.materialReceive);
    BlocProvider.of<MaterialReceiveLocalBloc>(context)
        .add(const ClearMaterialReceiveMaterialsLocal());
    context.pop();
    Fluttertoast.showToast(
        msg: "Material Issue Created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);

    context.read<MaterialReceiveBloc>().add(
          GetMaterialReceives(
            filterMaterialReceiveInput: FilterMaterialReceiveInput(),
            orderBy: OrderByMaterialReceiveInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 10),
          ),
        );
  }

  _buildOnCreateFailed(BuildContext context) {
    Fluttertoast.showToast(
        msg: "Create Material Issue Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    // final materialReceiveFormCubit = context.watch<MaterialReceiveFormCubit>();
    // final warehouseDropdown = materialReceiveFormCubit.state.warehouseDropdown;
    return BlocProvider(
      create: (context) => MaterialReceiveWarehouseFormCubit(),
      child: BlocBuilder<MaterialReceiveLocalBloc, MaterialReceiveLocalState>(
        builder: (localContext, localState) {
          return BlocBuilder<MaterialReceiveWarehouseFormCubit,
                  MaterialReceiveWarehouseFormState>(
              builder: (warehouseFormContext, warehouseFormState) {
            return BlocConsumer<MaterialReceiveBloc, MaterialReceiveState>(
              listener: (issueContext, issueState) {
                debugPrint("Material Issue Create Page: $issueState");
                if (issueState is CreateMaterialReceiveSuccess) {
                  _buildOnCreateSuccess(issueContext);
                } else if (issueState is CreateMaterialReceiveFailed) {
                  _buildOnCreateFailed(issueContext);
                }
              },
              builder: (issueContext, issueState) {
                return Scaffold(
                    appBar: AppBar(title: const Text("Create Material Issue")),
                    bottomSheet: _buildButtons(issueContext, localState,
                        issueState, warehouseFormState, warehouseFormContext),
                    body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<WarehouseBloc, WarehouseState>(
                          builder: (warehouseContext, warehouseState) {
                            final warehouseForm = warehouseFormContext
                                .watch<MaterialReceiveWarehouseFormCubit>();

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  CustomDropdown(
                                    onSelected: (dynamic value) {
                                      warehouseForm.warehouseChanged(value);
                                      context.read<ProductBloc>().add(
                                            GetWarehouseProducts(
                                              getProductsInputEntity:
                                                  GetWarehouseProductsInputEntity(
                                                filterWarehouseProductInput:
                                                    FilterWarehouseProductInput(
                                                        warehouseId: value.id),
                                              ),
                                            ),
                                          );
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
                                    label: 'From Warehouse',
                                    trailingIcon:
                                        warehouseState is WarehousesLoading
                                            ? const CircularProgressIndicator()
                                            : null,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Materials to be issued:",
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  (localState.materialReceiveMaterials == null ||
                                          localState
                                              .materialReceiveMaterials!.isEmpty)
                                      ? const EmptyList()
                                      : MaterialReceiveInputList(
                                          materialReceives: localState
                                              .materialReceiveMaterials!,
                        
                                        ),
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
    MaterialReceiveLocalState localState,
    MaterialReceiveState state,
    MaterialReceiveWarehouseFormState warehouseFormState,
    BuildContext warehouseFormContext,
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
                    value: warehouseFormContext
                        .read<MaterialReceiveWarehouseFormCubit>(),
                  ),
                  BlocProvider<MaterialReceiveFormCubit>(
                    create: (_) => MaterialReceiveFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CreateMaterialReceiveForm(),
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
          onPressed: (state is CreateMaterialReceiveLoading ||
                  localState.materialReceiveMaterials == null ||
                  localState.materialReceiveMaterials!.isEmpty)
              ? null
              : () {
                  context.read<MaterialReceiveBloc>().add(
                        CreateMaterialReceiveEvent(
                          createMaterialReceiveParamsEntity:
                              CreateMaterialReceiveParamsEntity(
                            projectId: context
                                    .read<ProjectBloc>()
                                    .state
                                    .selectedProjectId ??
                                "",
                            preparedById: USER_ID,
                            warehouseStoreId:
                                warehouseFormState.warehouseDropdown.value,
                            materialReceiveMaterials:
                                localState.materialReceiveMaterials!
                                    .map((e) => MaterialReceiveMaterialEntity(
                                          quantity: e.quantity,
                                          remark: e.remark,
                                          useType: e.useType,
                                          subStructureDescription:
                                              e.subStructureDescription,
                                          superStructureDescription:
                                              e.superStructureDescription,
                                          material: e.material,
                                        ))
                                    .toList(),
                          ),
                        ),
                      );

                  BlocProvider.of<MaterialReceiveBloc>(context)
                      .add(const GetMaterialReceives());

                  context.read<MaterialReceiveBloc>().add(
                        GetMaterialReceives(
                          filterMaterialReceiveInput: FilterMaterialReceiveInput(),
                          orderBy: OrderByMaterialReceiveInput(createdAt: "desc"),
                          paginationInput: PaginationInput(skip: 0, take: 10),
                        ),
                      );
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is CreateMaterialReceiveLoading
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
              const Text('Create Material Issue')
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
      return 'This field is required';
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
