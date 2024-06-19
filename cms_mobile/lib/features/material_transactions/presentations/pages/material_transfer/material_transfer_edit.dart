import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/edit/edit_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/material_transfers_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/material_transfers_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_transfer_form/material_transfer_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transfer/create_material_transfer_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transfer/material_transfer_input_list.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class MaterialTransferEditPage extends StatefulWidget {
  final String materialTransferId;
  const MaterialTransferEditPage({super.key, required this.materialTransferId});

  @override
  State<MaterialTransferEditPage> createState() =>
      _MaterialTransferEditPageState();
}

class _MaterialTransferEditPageState extends State<MaterialTransferEditPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  WarehouseDropdown warehouseDropdown = WarehouseDropdown.pure('');
  WarehouseEntity? selectedWarehouse;

  _buildOnEditSuccess(BuildContext context) {
    context.goNamed(RouteNames.materialTransfer);

    BlocProvider.of<MaterialTransferLocalBloc>(context)
        .add(const ClearMaterialTransferMaterialsLocal());
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
    // final materialTransferFormCubit = context.watch<MaterialTransferFormCubit>();
    // final warehouseDropdown = materialTransferFormCubit.state.warehouseDropdown;

    return MultiBlocProvider(
      providers: [
        BlocProvider<MaterialTransferDetailsCubit>(
          create: (context) => sl<MaterialTransferDetailsCubit>()
            ..onGetMaterialTransferDetails(
                materialTransferId: widget.materialTransferId),
        )
      ],
      child: BlocBuilder<MaterialTransferDetailsCubit,
          MaterialTransferDetailsState>(
        builder: (context, state) {
          if (state is MaterialTransferDetailsLoading) {
            return const Center(
                child: Column(
              children: [
                Text("Loading Material Issue Details"),
                CircularProgressIndicator(),
              ],
            ));
          } else if (state is MaterialTransferDetailsFailed) {
            return Text(state.error);
          } else if (state is MaterialTransferDetailsSuccess) {
            final materialTransfer = state.materialTransfer;
            final project = materialTransfer?.projectId;
            final preparedBy = materialTransfer?.preparedBy;
            final approvedBy = materialTransfer?.approvedBy;
            final materialTransferMaterials = materialTransfer?.items ?? [];
            selectedWarehouse ??= materialTransfer?.receivingWarehouseStore;
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
                  return BlocBuilder<MaterialTransferLocalBloc,
                      MaterialTransferLocalState>(
                    builder: (localContext, localState) {
                      return Builder(builder: (context) {
                        // final warehouseForm = warehouseFormContext
                        //     .watch<MaterialTransferWarehouseFormCubit>();

                        context.read<ProductBloc>().add(
                              GetWarehouseProducts(
                                getProductsInputEntity:
                                    GetWarehouseProductsInputEntity(
                                  filterWarehouseProductInput:
                                      FilterWarehouseProductInput(
                                          warehouseId:
                                              materialTransfer?.materialGroup),
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
                            // localContext.read<MaterialTransferLocalBloc>().add(
                            //         AddMaterialTransferMaterialsLocal(
                            //             materialTransferMaterials.map(
                            //       (e) {
                            //         return MaterialTransferMaterialEntity(
                            //             quantity: e.quantity!,
                            //             useType: e.useType!,
                            //             material: itemState.warehouseProducts!
                            //                 .firstWhere((element) =>
                            //                     element.productVariant.id ==
                            //                     e.productVariant?.id),
                            //             remark: e.remark,
                            //             subStructureDescription:
                            //                 e.subStructureDescription,
                            //             superStructureDescription:
                            //                 e.superStructureDescription);
                            //       },
                            //     ).toList()));

                            return BlocConsumer<MaterialTransferBloc,
                                MaterialTransferState>(
                              listener: (issueContext, issueState) {
                                if (issueState is EditMaterialTransferSuccess) {
                                  _buildOnEditSuccess(issueContext);
                                } else if (issueState is EditMaterialTransferFailed) {
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
                                          (localState.materialTransferMaterials ==
                                                      null ||
                                                  localState
                                                      .materialTransferMaterials!
                                                      .isEmpty)
                                              ? const EmptyList()
                                              : MaterialTransferInputList(
                                                  materialTransfers: localState
                                                          .materialTransferMaterials ??
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
    MaterialTransferLocalState localState,
    MaterialTransferState state,
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
                  BlocProvider<MaterialTransferFormCubit>(
                    create: (_) => MaterialTransferFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CreateMaterialTransferForm(),
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
          onPressed: (state is EditMaterialTransferLoading ||
                  localState.materialTransferMaterials == null ||
                  localState.materialTransferMaterials!.isEmpty)
              ? null
              : () {
                  // context
                  //     .read<EditMaterialTransferCubit>()
                  //     .onEditMaterialTransfer(
                  //         editMaterialTransferParamsEntity:
                  //             EditMaterialTransferParamsEntity(
                  //       updateMaterialTransferId: widget.materialTransferId,
                  //       approved: "approved",
                  //       approvedById: "approvedById",
                  //       warehouseStoreId: warehouseDropdown?.value ?? "",
                  //       materialTransferMaterials:
                  //           localState.materialTransferMaterials!
                  //               .map((e) => MaterialTransferMaterialEntity(
                  //                     quantity: e.quantity,
                  //                     remark: e.remark,
                  //                     useType: e.useType,
                  //                     subStructureDescription:
                  //                         e.subStructureDescription,
                  //                     superStructureDescription:
                  //                         e.superStructureDescription,
                  //                     material: e.material,
                  //                   ))
                  //               .toList(),
                  //     ));
                
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is EditMaterialTransferLoading
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
