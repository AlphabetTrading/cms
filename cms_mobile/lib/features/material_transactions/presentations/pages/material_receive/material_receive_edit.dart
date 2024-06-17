import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/edit/edit_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_state.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/create_material_receive_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/material_receive_input_list.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class MaterialReceiveEditPage extends StatefulWidget {
  final String materialReceiveId;
  const MaterialReceiveEditPage({super.key, required this.materialReceiveId});

  @override
  State<MaterialReceiveEditPage> createState() =>
      _MaterialReceiveEditPageState();
}

class _MaterialReceiveEditPageState extends State<MaterialReceiveEditPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  WarehouseDropdown warehouseDropdown = WarehouseDropdown.pure('');
  WarehouseEntity? selectedWarehouse;

  _buildOnEditSuccess(BuildContext context) {
    context.goNamed(RouteNames.materialReceiving);

    BlocProvider.of<MaterialReceiveLocalBloc>(context)
        .add(const ClearMaterialReceiveMaterialsLocal());
    Fluttertoast.showToast(
        msg: "Material Receive Editd",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _buildOnEditFailed(BuildContext context) {
    Fluttertoast.showToast(
        msg: "Edit Material Receive Failed",
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

    return MultiBlocProvider(
      providers: [
        BlocProvider<MaterialReceiveDetailsCubit>(
          create: (context) => sl<MaterialReceiveDetailsCubit>()
            ..onGetMaterialReceiveDetails(
                materialReceiveId: widget.materialReceiveId),
        )
      ],
      child:
          BlocBuilder<MaterialReceiveDetailsCubit, MaterialReceiveDetailsState>(
        builder: (context, state) {
          if (state is MaterialReceiveDetailsLoading) {
            return const Center(
                child: Column(
              children: [
                Text("Loading Material Receive Details"),
                CircularProgressIndicator(),
              ],
            ));
          } else if (state is MaterialReceiveDetailsFailed) {
            return Text(state.error);
          } else if (state is MaterialReceiveDetailsSuccess) {
            final materialReceive = state.materialReceive;
            final project = materialReceive?.project;
            final preparedBy = materialReceive?.preparedBy;
            final approvedBy = materialReceive?.approvedBy;
            final materialReceiveMaterials = materialReceive?.items ?? [];
            selectedWarehouse ??= materialReceive?.warehouse;
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
                  return BlocBuilder<MaterialReceiveLocalBloc,
                      MaterialReceiveLocalState>(
                    builder: (localContext, localState) {
                      return Builder(builder: (context) {
                        // final warehouseForm = warehouseFormContext
                        //     .watch<MaterialReceiveWarehouseFormCubit>();

                        context.read<ProductBloc>().add(
                              GetWarehouseProducts(
                                getProductsInputEntity:
                                    GetWarehouseProductsInputEntity(
                                  filterWarehouseProductInput:
                                      FilterWarehouseProductInput(
                                          warehouseId:
                                              materialReceive?.warehouse?.id),
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
                            localContext.read<MaterialReceiveLocalBloc>().add(
                                    AddMaterialReceiveMaterialsLocal(
                                        materialReceiveMaterials.map(
                                  (e) {
                                    return MaterialReceiveMaterialEntity(
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

                            return BlocConsumer<MaterialReceiveBloc,
                                MaterialReceiveState>(
                              listener: (receiveContext, receiveState) {
                                if (receiveState
                                    is EditMaterialReceiveSuccess) {
                                  _buildOnEditSuccess(receiveContext);
                                } else if (receiveState
                                    is EditMaterialReceiveFailed) {
                                  _buildOnEditFailed(receiveContext);
                                }
                              },
                              builder: (receiveContext, receiveState) {
                                return Scaffold(
                                  appBar: AppBar(
                                      title:
                                          const Text("Edit Material Receive")),
                                  bottomSheet: _buildButtons(
                                      receiveContext, localState, receiveState),
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
                                            "Materials to be received:",
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          (localState.materialReceiveMaterials ==
                                                      null ||
                                                  localState
                                                      .materialReceiveMaterials!
                                                      .isEmpty)
                                              ? const EmptyList()
                                              : MaterialReceiveInputList(
                                                  materialReceives: localState
                                                          .materialReceiveMaterials ??
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
    MaterialReceiveLocalState localState,
    MaterialReceiveState state,
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
          onPressed: (state is EditMaterialReceiveLoading ||
                  localState.materialReceiveMaterials == null ||
                  localState.materialReceiveMaterials!.isEmpty)
              ? null
              : () {
                  context
                      .read<EditMaterialReceiveCubit>()
                      .onEditMaterialReceive(
                          editMaterialReceiveParamsEntity:
                              EditMaterialReceiveParamsEntity(
                        updateMaterialReceiveId: widget.materialReceiveId,
                        approved: "approved",
                        approvedById: "approvedById",
                        warehouseStoreId: warehouseDropdown?.value ?? "",
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
                      ));
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is EditMaterialReceiveLoading
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
              const Text('Edit Material Receive')
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
