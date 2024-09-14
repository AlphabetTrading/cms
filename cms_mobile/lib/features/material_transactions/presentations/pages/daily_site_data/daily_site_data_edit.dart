import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/edit/edit_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/daily_site_data_form/daily_site_data_form_cubit.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class DailySiteDataEditPage extends StatefulWidget {
  final String dailySiteDataId;
  const DailySiteDataEditPage({super.key, required this.dailySiteDataId});

  @override
  State<DailySiteDataEditPage> createState() => _DailySiteDataEditPageState();
}

class _DailySiteDataEditPageState extends State<DailySiteDataEditPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  WarehouseDropdown warehouseDropdown = const WarehouseDropdown.pure('');
  WarehouseEntity? selectedWarehouse;

  _buildOnEditSuccess(BuildContext context) {
    context.goNamed(RouteNames.dailySiteData);

    BlocProvider.of<DailySiteDataLocalBloc>(context)
        .add(const ClearDailySiteDataMaterialsLocal());
    Fluttertoast.showToast(
        msg: "Material Issue Editd",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromARGB(255, 1, 135, 23),
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
    // final dailySiteDataFormCubit = context.watch<DailySiteDataFormCubit>();
    // final warehouseDropdown = dailySiteDataFormCubit.state.warehouseDropdown;

    return MultiBlocProvider(
      providers: [
        BlocProvider<DailySiteDataDetailsCubit>(
          create: (context) => sl<DailySiteDataDetailsCubit>()
            ..onGetDailySiteDataDetails(
                dailySiteDataId: widget.dailySiteDataId),
        )
      ],
      child: BlocBuilder<DailySiteDataDetailsCubit, DailySiteDataDetailsState>(
        builder: (context, state) {
          if (state is DailySiteDataDetailsLoading) {
            return const Center(
                child: Column(
              children: [
                Text("Loading Material Issue Details"),
                CircularProgressIndicator(),
              ],
            ));
          } else if (state is DailySiteDataDetailsFailed) {
            return Text(state.error);
          } else if (state is DailySiteDataDetailsSuccess) {
            final dailySiteData = state.dailySiteData;
            final preparedBy = dailySiteData?.preparedBy;
            final approvedBy = dailySiteData?.approvedBy;
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
                  return BlocBuilder<DailySiteDataLocalBloc,
                      DailySiteDataLocalState>(
                    builder: (localContext, localState) {
                      return Builder(builder: (context) {
                        // final warehouseForm = warehouseFormContext
                        //     .watch<DailySiteDataWarehouseFormCubit>();

                        context.read<ProductBloc>().add(
                              GetWarehouseProducts(
                                getProductsInputEntity:
                                    GetWarehouseProductsInputEntity(
                                  filterWarehouseProductInput:
                                      FilterWarehouseProductInput(
                                          warehouseId:
                                              dailySiteData?.approvedById),
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
                            // localContext.read<DailySiteDataLocalBloc>().add(
                            //         AddDailySiteDataMaterialsLocal(
                            //       },
                            //     ).toList()));

                            return BlocConsumer<DailySiteDataBloc,
                                DailySiteDataState>(
                              listener: (issueContext, issueState) {
                                if (issueState is EditDailySiteDataSuccess) {
                                  _buildOnEditSuccess(issueContext);
                                } else if (issueState
                                    is EditDailySiteDataFailed) {
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
                                          // (localState.dailySiteDataMaterials ==
                                          //             null ||
                                          //         localState
                                          //             .dailySiteDataMaterials!
                                          //             .isEmpty)
                                          //     ? const EmptyList()
                                          //     : DailySiteDataInputList(
                                          //         dailySiteDatas: localState
                                          //                 .dailySiteDataMaterials ??
                                          //             [],
                                          //       ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        });
                      });
                    },
                  );
                }
                return const SizedBox();
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
    DailySiteDataLocalState localState,
    DailySiteDataState state,
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
                  BlocProvider<DailySiteDataFormCubit>(
                    create: (_) => DailySiteDataFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(32.0),
                      // child: CreateDailySiteDataForm(),
                      child: SizedBox.shrink(),
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
          onPressed: (state is EditDailySiteDataLoading ||
                  localState.dailySiteDataMaterials == null ||
                  localState.dailySiteDataMaterials!.isEmpty)
              ? null
              : () {
                  context.read<EditDailySiteDataCubit>().onEditDailySiteData(
                          editDailySiteDataParamsEntity:
                              EditDailySiteDataParamsEntity(
                        updateDailySiteDataId: widget.dailySiteDataId,
                        approved: "approved",
                        approvedById: "approvedById",
                        tasks: const [],
                      ));
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is EditDailySiteDataLoading
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
