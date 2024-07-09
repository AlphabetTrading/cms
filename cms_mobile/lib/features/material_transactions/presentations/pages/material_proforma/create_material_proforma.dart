import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/utils/ids.dart';

import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_proformas/material_proforma_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma_local/material_proforma_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma_local/material_proforma_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma_local/material_proforma_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_proforma_form/material_proforma_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_proforma_form/material_proforma_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class MaterialProformaCreatePage extends StatefulWidget {
  const MaterialProformaCreatePage({super.key});

  @override
  State<MaterialProformaCreatePage> createState() =>
      _MaterialProformaCreatePageState();
}

class _MaterialProformaCreatePageState
    extends State<MaterialProformaCreatePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  // final String savedUserId = await GQLClient.getUserIdFromStorage();

  _buildOnCreateSuccess(BuildContext context) {
    // context.goNamed(RouteNames.materialProforma);
    BlocProvider.of<MaterialProformaLocalBloc>(context)
        .add(const ClearMaterialProformaMaterialsLocal());
    context.pop();
    Fluttertoast.showToast(
        msg: "Material Proforma Created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);

    context.read<MaterialProformaBloc>().add(
          GetMaterialProformas(
            filterMaterialProformaInput: FilterMaterialProformaInput(),
            orderBy: OrderByMaterialProformaInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 20),
          ),
        );
  }

  _buildOnCreateFailed(BuildContext context) {
    Fluttertoast.showToast(
        msg: "Create Material Proforma Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    // final materialProformaFormCubit = context.watch<MaterialProformaFormCubit>();
    // final warehouseDropdown = materialProformaFormCubit.state.warehouseDropdown;
    return BlocProvider(
      create: (context) => MaterialProformaWarehouseFormCubit(),
      child: BlocBuilder<MaterialProformaLocalBloc, MaterialProformaLocalState>(
        builder: (localContext, localState) {
          return BlocBuilder<MaterialProformaWarehouseFormCubit,
                  MaterialProformaWarehouseFormState>(
              builder: (warehouseFormContext, warehouseFormState) {
            return BlocConsumer<MaterialProformaBloc, MaterialProformaState>(
              listener: (issueContext, issueState) {
                debugPrint("Material Proforma Create Page: $issueState");
                if (issueState is CreateMaterialProformaSuccess) {
                  _buildOnCreateSuccess(issueContext);
                } else if (issueState is CreateMaterialProformaFailed) {
                  _buildOnCreateFailed(issueContext);
                }
              },
              builder: (issueContext, issueState) {
                return Scaffold(
                    appBar: AppBar(title: const Text("Create Material Proforma")),
                    bottomSheet: _buildButtons(issueContext, localState,
                        issueState, warehouseFormState, warehouseFormContext),
                    body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<WarehouseBloc, WarehouseState>(
                          builder: (warehouseContext, warehouseState) {
                            final warehouseForm = warehouseFormContext
                                .watch<MaterialProformaWarehouseFormCubit>();

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
                                  (localState.materialProformaMaterials ==
                                              null ||
                                          localState.materialProformaMaterials!
                                              .isEmpty)
                                      ? const EmptyList() : const SizedBox(),
                                      // ? const EmptyList()
                                      // : MaterialProformaInputList(
                                      //     materialProformas: localState
                                      //         ?.materialProformaMaterials!,
                                      //   ),
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
    MaterialProformaLocalState localState,
    MaterialProformaState state,
    MaterialProformaWarehouseFormState warehouseFormState,
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
                        .read<MaterialProformaWarehouseFormCubit>(),
                  ),
                  BlocProvider<MaterialProformaFormCubit>(
                    create: (_) => MaterialProformaFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        "Add Material",
                      ),
                      // child: CreateMaterialProformaForm(),
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
          onPressed: (state is CreateMaterialProformaLoading ||
                  localState.materialProformaMaterials == null ||
                  localState.materialProformaMaterials!.isEmpty)
              ? null
              : () {
                  context.read<MaterialProformaBloc>().add(
                        CreateMaterialProformaEvent(
                          createMaterialProformaParamsEntity:
                              CreateMaterialProformaParamsEntity(
                            projectId: context
                                    .read<ProjectBloc>()
                                    .state
                                    .selectedProjectId ??
                                "",
                            preparedById:
                                context.read<AuthBloc>().state.user?.id ??
                                    USER_ID,
                            warehouseStoreId:
                                warehouseFormState.warehouseDropdown.value,
                            materialProformaMaterials:
                                localState.materialProformaMaterials!
                                    .map((e) => MaterialProformaMaterialEntity(
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

                  context.read<MaterialProformaBloc>().add(
                        GetMaterialProformas(
                          filterMaterialProformaInput:
                              FilterMaterialProformaInput(),
                          orderBy:
                              OrderByMaterialProformaInput(createdAt: "desc"),
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
              state is CreateMaterialProformaLoading
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
              const Text('Create Material Proforma')
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
