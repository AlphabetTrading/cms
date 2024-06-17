import 'package:cms_mobile/core/entities/pagination.dart';

import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/create/create_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/purchase_order/create_material_issue_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/purchase_order/purchase_order_input_list.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class PurchaseOrderCreatePage extends StatefulWidget {
  const PurchaseOrderCreatePage({super.key});

  @override
  State<PurchaseOrderCreatePage> createState() =>
      _PurchaseOrderCreatePageState();
}

class _PurchaseOrderCreatePageState extends State<PurchaseOrderCreatePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  // final String savedUserId = await GQLClient.getUserIdFromStorage();

  _buildOnCreateSuccess(BuildContext context) {
    // context.goNamed(RouteNames.purchaseOrder);
    BlocProvider.of<PurchaseOrderLocalBloc>(context)
        .add(const ClearPurchaseOrderMaterialsLocal());
    context.pop();
    Fluttertoast.showToast(
        msg: "Material Issue Created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);

    context.read<PurchaseOrderBloc>().add(
          GetPurchaseOrders(
            filterPurchaseOrderInput: FilterPurchaseOrderInput(),
            orderBy: OrderByPurchaseOrderInput(createdAt: "desc"),
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
    // final purchaseOrderFormCubit = context.watch<PurchaseOrderFormCubit>();
    // final warehouseDropdown = purchaseOrderFormCubit.state.warehouseDropdown;
    return BlocProvider(
      create: (context) => PurchaseOrderWarehouseFormCubit(),
      child: BlocBuilder<PurchaseOrderLocalBloc, PurchaseOrderLocalState>(
        builder: (localContext, localState) {
          return BlocBuilder<PurchaseOrderWarehouseFormCubit,
                  PurchaseOrderWarehouseFormState>(
              builder: (warehouseFormContext, warehouseFormState) {
            return BlocConsumer<PurchaseOrderBloc, PurchaseOrderState>(
              listener: (issueContext, issueState) {
                debugPrint("Material Issue Create Page: $issueState");
                if (issueState is CreatePurchaseOrderSuccess) {
                  _buildOnCreateSuccess(issueContext);
                } else if (issueState is CreatePurchaseOrderFailed) {
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
                                .watch<PurchaseOrderWarehouseFormCubit>();

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
                                  (localState.purchaseOrderMaterials == null ||
                                          localState
                                              .purchaseOrderMaterials!.isEmpty)
                                      ? const EmptyList()
                                      : PurchaseOrderInputList(
                                          purchaseOrders: localState
                                              .purchaseOrderMaterials!,
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
    PurchaseOrderLocalState localState,
    PurchaseOrderState state,
    PurchaseOrderWarehouseFormState warehouseFormState,
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
                        .read<PurchaseOrderWarehouseFormCubit>(),
                  ),
                  BlocProvider<PurchaseOrderFormCubit>(
                    create: (_) => PurchaseOrderFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CreatePurchaseOrderForm(),
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
          onPressed: (state is CreatePurchaseOrderLoading ||
                  localState.purchaseOrderMaterials == null ||
                  localState.purchaseOrderMaterials!.isEmpty)
              ? null
              : () {
                  // context.read<CreatePurchaseOrderCubit>().add(
                  //       CreatePurchaseOrderEvent(
                  //         createPurchaseOrderParamsEntity:
                  //             CreatePurchaseOrderParamsEntity(
                  //           projectId: context
                  //                   .read<ProjectBloc>()
                  //                   .state
                  //                   .selectedProjectId ??
                  //               "",
                  //           preparedById: USER_ID,
                  //           warehouseStoreId:
                  //               warehouseFormState.warehouseDropdown.value,
                  //           purchaseOrderMaterials:
                  //               localState.purchaseOrderMaterials!
                  //                   .map((e) => PurchaseOrderMaterialEntity(
                  //                         quantity: e.quantity,
                  //                         remark: e.remark,
                  //                         useType: e.useType,
                  //                         subStructureDescription:
                  //                             e.subStructureDescription,
                  //                         superStructureDescription:
                  //                             e.superStructureDescription,
                  //                         material: e.material,
                  //                       ))
                  //                   .toList(),
                  //         ),
                  //       ),
                  //     );

                  BlocProvider.of<PurchaseOrderBloc>(context)
                      .add(const GetPurchaseOrders());

                  context.read<PurchaseOrderBloc>().add(
                        GetPurchaseOrders(
                          filterPurchaseOrderInput: FilterPurchaseOrderInput(),
                          orderBy: OrderByPurchaseOrderInput(createdAt: "desc"),
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
              state is CreatePurchaseOrderLoading
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
