import 'package:cms_mobile/core/entities/pagination.dart';

import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_transfer/material_transfer_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/material_transfers_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/material_transfers_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/material_transfers_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer_local/material_transfer_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_transfer_form/material_transfer_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_transfer_form/material_transfer_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transfer/create_material_transfer_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transfer/material_transfer_input_list.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class MaterialTransferCreatePage extends StatefulWidget {
  const MaterialTransferCreatePage({super.key});

  @override
  State<MaterialTransferCreatePage> createState() =>
      _MaterialTransferCreatePageState();
}

class _MaterialTransferCreatePageState
    extends State<MaterialTransferCreatePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  // final String savedUserId = await GQLClient.getUserIdFromStorage();

  _buildOnCreateSuccess(BuildContext context) {
    // context.goNamed(RouteNames.materialTransfer);
    BlocProvider.of<MaterialTransferLocalBloc>(context)
        .add(const ClearMaterialTransferMaterialsLocal());
    context.pop();
    Fluttertoast.showToast(
        msg: "Material Issue Created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);

    context.read<MaterialTransferBloc>().add(
          GetMaterialTransfers(
            filterMaterialTransferInput: FilterMaterialTransferInput(),
            orderBy: OrderByMaterialTransferInput(createdAt: "desc"),
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
    // final materialTransferFormCubit = context.watch<MaterialTransferFormCubit>();
    // final warehouseDropdown = materialTransferFormCubit.state.warehouseDropdown;
    return BlocProvider(
      create: (context) => MaterialTransferWarehouseFormCubit(),
      child: BlocBuilder<MaterialTransferLocalBloc, MaterialTransferLocalState>(
        builder: (localContext, localState) {
          return BlocBuilder<MaterialTransferWarehouseFormCubit,
                  MaterialTransferWarehouseFormState>(
              builder: (warehouseFormContext, warehouseFormState) {
            return BlocConsumer<MaterialTransferBloc, MaterialTransferState>(
              listener: (issueContext, issueState) {
                debugPrint("Material Issue Create Page: $issueState");
                if (issueState is CreateMaterialTransferSuccess) {
                  _buildOnCreateSuccess(issueContext);
                } else if (issueState is CreateMaterialTransferFailed) {
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
                                .watch<MaterialTransferWarehouseFormCubit>();

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
                                                label: e.name ?? "", value: e))
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
                                  (localState.materialTransferMaterials ==
                                              null ||
                                          localState.materialTransferMaterials!
                                              .isEmpty)
                                      ? const EmptyList()
                                      : MaterialTransferInputList(
                                          materialTransfers: localState
                                              .materialTransferMaterials!,
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
    MaterialTransferLocalState localState,
    MaterialTransferState state,
    MaterialTransferWarehouseFormState warehouseFormState,
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
                        .read<MaterialTransferWarehouseFormCubit>(),
                  ),
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
          onPressed: (state is CreateMaterialTransferLoading ||
                  localState.materialTransferMaterials == null ||
                  localState.materialTransferMaterials!.isEmpty)
              ? null
              : () {
                  // context.read<MaterialTransferBloc>().add(
                  //       CreateMaterialTransferEvent(
                  //         createMaterialTransferParamsEntity:
                  //             CreateMaterialTransferParamsEntity(
                  //                 projectId: context
                  //                         .read<ProjectBloc>()
                  //                         .state
                  //                         .selectedProjectId ??
                  //                     "",
                  //                 returnedById: USER_ID,
                  //                 materialTransferMaterials: localState
                  //                     .materialTransferMaterials!
                  //                     .map((e) => MaterialTransferEntity(
                  //                           quantity: e.quantity,
                  //                           remark: e.remark,
                  //                           subStructureDescription:
                  //                               e.subStructureDescription,
                  //                           superStructureDescription:
                  //                               e.superStructureDescription,
                  //                           useType: e.useType,
                  //                         ))).toList(),
                  //         receivingStoreId: '',
                  //       ),
                  //     );

                  BlocProvider.of<MaterialTransferBloc>(context)
                      .add(const GetMaterialTransfers());

                  context.read<MaterialTransferBloc>().add(
                        GetMaterialTransfers(
                          filterMaterialTransferInput:
                              FilterMaterialTransferInput(),
                          orderBy:
                              OrderByMaterialTransferInput(createdAt: "desc"),
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
              state is CreateMaterialTransferLoading
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
