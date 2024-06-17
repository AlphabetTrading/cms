import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/edit/edit_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_issue_form/material_issue_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_issue/create_material_issue_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_issue/material_issue_input_list.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class MaterialIssueEditPage extends StatefulWidget {
  final String materialIssueId;
  const MaterialIssueEditPage({super.key, required this.materialIssueId});

  @override
  State<MaterialIssueEditPage> createState() => _MaterialIssueEditPageState();
}

class _MaterialIssueEditPageState extends State<MaterialIssueEditPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  WarehouseDropdown warehouseDropdown = WarehouseDropdown.pure('');
  WarehouseEntity? selectedWarehouse;

  _buildOnEditSuccess(BuildContext context) {
    context.goNamed(RouteNames.materialIssue);

    BlocProvider.of<MaterialIssueLocalBloc>(context)
        .add(const ClearMaterialIssueMaterialsLocal());
    Fluttertoast.showToast(
        msg: "Material Issue Editd",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _buildOnEditFailed(BuildContext context) {
    Fluttertoast.showToast(
        msg: "Edit Material Issue Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    // final materialIssueFormCubit = context.watch<MaterialIssueFormCubit>();
    // final warehouseDropdown = materialIssueFormCubit.state.warehouseDropdown;

    return MultiBlocProvider(
      providers: [
        BlocProvider<MaterialIssueDetailsCubit>(
          create: (context) => sl<MaterialIssueDetailsCubit>()
            ..onGetMaterialIssueDetails(
                materialIssueId: widget.materialIssueId),
        )
      ],
      child: BlocBuilder<MaterialIssueDetailsCubit, MaterialIssueDetailsState>(
        builder: (context, state) {
          if (state is MaterialIssueDetailsLoading) {
            return const Center(
                child: Column(
              children: [
                Text("Loading Material Issue Details"),
                CircularProgressIndicator(),
              ],
            ));
          } else if (state is MaterialIssueDetailsFailed) {
            return Text(state.error);
          } else if (state is MaterialIssueDetailsSuccess) {
            final materialIssue = state.materialIssue;
            final project = materialIssue?.project;
            final preparedBy = materialIssue?.preparedBy;
            final approvedBy = materialIssue?.approvedBy;
            final materialIssueMaterials = materialIssue?.items ?? [];
            selectedWarehouse ??= materialIssue?.warehouse;
            return BlocBuilder<WarehouseBloc, WarehouseState>(
              builder: (warehouseContext, warehouseState) {
                if (warehouseState is WarehousesFailed) {
                  return Text(warehouseState.error.toString());
                } else if (warehouseState is WarehousesLoading ||
                    warehouseState is WarehouseInitial) {
                  return const Center(
                      child: Column(
                    children: [
                      Text("Loading Warehouses"),
                      CircularProgressIndicator(),
                    ],
                  ));
                } else if (warehouseState is WarehousesSuccess) {
                  return BlocBuilder<MaterialIssueLocalBloc,
                      MaterialIssueLocalState>(
                    builder: (localContext, localState) {
                      return Builder(builder: (context) {
                        // final warehouseForm = warehouseFormContext
                        //     .watch<MaterialIssueWarehouseFormCubit>();

                        context.read<ProductBloc>().add(
                              GetWarehouseProducts(
                                getProductsInputEntity:
                                    GetWarehouseProductsInputEntity(
                                  filterWarehouseProductInput:
                                      FilterWarehouseProductInput(
                                          warehouseId:
                                              materialIssue?.warehouse?.id),
                                ),
                              ),
                            );

                        return BlocBuilder<ProductBloc, ProductState>(
                            builder: (itemContext, itemState) {
                          if (itemState is WarehouseProductsFailed) {
                            return Text(itemState.error.toString());
                          }
                          if (itemState is WarehouseProductsLoading) {
                            return const Center(
                                child: Column(
                              children: [
                                Text('Loading warehouse items'),
                                CircularProgressIndicator(),
                              ],
                            ));
                          }
                          if (itemState is WarehouseProductsSuccess) {
                            localContext.read<MaterialIssueLocalBloc>().add(
                                    AddMaterialIssueMaterialsLocal(
                                        materialIssueMaterials.map(
                                  (e) {
                                    return MaterialIssueMaterialEntity(
                                        quantity: e.quantity!,
                                        useType: e.useType!,
                                        material: itemState.warehouseProducts!
                                            .firstWhere((element) =>
                                                element.productVariant.id ==
                                                e.productVariant?.id),
                                        remark: e.remark,
                                        subStructureDescription:
                                            e.subStructureDescription,
                                        superStructureDescription:
                                            e.superStructureDescription);
                                  },
                                ).toList()));

                            return BlocConsumer<MaterialIssueBloc,
                                MaterialIssueState>(
                              listener: (issueContext, issueState) {
                                if (issueState is EditMaterialIssueSuccess) {
                                  _buildOnEditSuccess(issueContext);
                                } else if (issueState
                                    is EditMaterialIssueFailed) {
                                  _buildOnEditFailed(issueContext);
                                }
                              },
                              builder: (issueContext, issueState) {
                                return Scaffold(
                                  appBar: AppBar(
                                      title: const Text("Edit Material Issue")),
                                  bottomSheet: _buildButtons(
                                      issueContext, localState, issueState),
                                  body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Column(
                                        children: [
                                          CustomDropdown(
                                            initialSelection: selectedWarehouse,
                                            onSelected: (dynamic value) {
                                              warehouseDropdown =
                                                  WarehouseDropdown.dirty(
                                                      value.id);
                                              selectedWarehouse = value;

                                              context.read<ProductBloc>().add(
                                                    GetWarehouseProducts(
                                                      getProductsInputEntity:
                                                          GetWarehouseProductsInputEntity(
                                                        filterWarehouseProductInput:
                                                            FilterWarehouseProductInput(
                                                                warehouseId:
                                                                    value.id),
                                                      ),
                                                    ),
                                                  );
                                              setState(() {});
                                            },
                                            dropdownMenuEntries: warehouseState
                                                    .warehouses
                                                    ?.map((e) =>
                                                        DropdownMenuEntry<
                                                                WarehouseEntity>(
                                                            label: e.name,
                                                            value: e))
                                                    .toList() ??
                                                [],
                                            enableFilter: false,
                                            errorMessage:
                                                warehouseDropdown.errorMessage,
                                            label: 'From Warehouse',
                                            trailingIcon: warehouseState
                                                    is WarehousesLoading
                                                ? const CircularProgressIndicator()
                                                : null,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Materials to be issued:",
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          (localState.materialIssueMaterials ==
                                                      null ||
                                                  localState
                                                      .materialIssueMaterials!
                                                      .isEmpty)
                                              ? const EmptyList()
                                              : MaterialIssueInputList(
                                                  materialIssues: localState
                                                          .materialIssueMaterials ??
                                                      [],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return SizedBox();
                        });
                      });
                    },
                  );
                }
                return SizedBox();
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  _buildButtons(
    BuildContext context,
    MaterialIssueLocalState localState,
    MaterialIssueState state,
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
                  BlocProvider<MaterialIssueFormCubit>(
                    create: (_) => MaterialIssueFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CreateMaterialIssueForm(),
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
          onPressed: (state is EditMaterialIssueLoading ||
                  localState.materialIssueMaterials == null ||
                  localState.materialIssueMaterials!.isEmpty)
              ? null
              : () {
                  context.read<EditMaterialIssueCubit>().onEditMaterialIssue(
                          editMaterialIssueParamsEntity:
                              EditMaterialIssueParamsEntity(
                        updateMaterialIssueId: widget.materialIssueId,
                        approved: "approved",
                        approvedById: "approvedById",
                        warehouseStoreId: warehouseDropdown?.value ?? "",
                        materialIssueMaterials:
                            localState.materialIssueMaterials!
                                .map((e) => MaterialIssueMaterialEntity(
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
                      ));
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is EditMaterialIssueLoading
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
              const Text('Edit Material Issue')
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
