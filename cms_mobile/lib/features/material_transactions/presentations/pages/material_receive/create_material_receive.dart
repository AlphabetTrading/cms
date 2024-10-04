import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/utils/ids.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/create/create_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/create_material_receive_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/material_receive_input_list.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse/warehouse_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class CreateMaterialReceivePage extends StatefulWidget {
  const CreateMaterialReceivePage({super.key});

  @override
  State<CreateMaterialReceivePage> createState() =>
      _CreateMaterialReceivePageState();
}

class _CreateMaterialReceivePageState extends State<CreateMaterialReceivePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  @override
  Widget build(BuildContext context) {
    // final materialReceiveFormCubit = context.watch<MaterialReceiveFormCubit>();
    // final warehouseDropdown = materialReceiveFormCubit.state.warehouseDropdown;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MaterialReceiveWarehouseFormCubit(),
        ),
        BlocProvider(
          create: (context) => sl<CreateMaterialReceiveCubit>(),
        ),
        // BlocProvider(
        //   create: (context) => sl<MaterialReceiveLocalBloc>(),
        // ),
      ],
      child: BlocBuilder<MaterialReceiveLocalBloc, MaterialReceiveLocalState>(
        builder: (localContext, localState) {
          return BlocBuilder<MaterialReceiveWarehouseFormCubit,
                  MaterialReceiveWarehouseFormState>(
              builder: (warehouseFormContext, warehouseFormState) {
            return BlocConsumer<CreateMaterialReceiveCubit,
                CreateMaterialReceiveState>(
              listener: (receivingContext, receivingState) {
                if (receivingState is CreateMaterialReceiveSuccess) {
                  showStatusMessage(
                    Status.SUCCESS,
                    "Material Receive Created",
                  );
                  context.read<MaterialReceiveBloc>().add(GetMaterialReceives(
                        filterMaterialReceiveInput:
                            FilterMaterialReceiveInput(),
                        orderBy: OrderByMaterialReceiveInput(createdAt: "desc"),
                        paginationInput: PaginationInput(skip: 0, take: 20),
                      ));
                  context.pop();
                } else if (receivingState is CreateMaterialReceiveFailed) {
                  showStatusMessage(
                    Status.FAILED,
                    "Create Material Receive Failed",
                  );
                }
              },
              builder: (receivingContext, receivingState) {
                final warehouseForm = warehouseFormContext
                    .watch<MaterialReceiveWarehouseFormCubit>();

                return Scaffold(
                    appBar:
                        AppBar(title: const Text("Create Material Receive")),
                    bottomSheet: _buildButtons(receivingContext, localState,
                        receivingState, warehouseForm),
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
                                                label: e.name ?? "", value: e))
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
                                  (localState.materialReceiveMaterials ==
                                              null ||
                                          localState.materialReceiveMaterials!
                                              .isEmpty)
                                      ? const EmptyList()
                                      : MaterialReceiveInputList(
                                          materialReceives: localState
                                              .materialReceiveMaterials!),
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
      CreateMaterialReceiveState state,
      MaterialReceiveWarehouseFormCubit warehouseForm) {
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
                  BlocProvider<MaterialReceiveFormCubit>(
                    create: (_) => MaterialReceiveFormCubit(),
                  ),
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
                  warehouseForm.onSubmit();
                  if (warehouseForm.state.isValid) {
                    context
                        .read<CreateMaterialReceiveCubit>()
                        .onCreateMaterialReceive(
                          createMaterialReceiveParamsEntity:
                              CreateMaterialReceiveParamsEntity(
                            projectId: context
                                    .read<ProjectBloc>()
                                    .state
                                    .selectedProjectId ??
                                "",
                            receivingStoreId:
                                warehouseForm.state.warehouseDropdown.value,
                            preparedById:
                                context.read<AuthBloc>().state.user?.id ??
                                    USER_ID,
                            materialReceiveMaterials: localState
                                .materialReceiveMaterials!
                                .map((e) => MaterialReceiveMaterialEntity(
                                      transportationCost: e.transportationCost,
                                      loadingCost: e.loadingCost,
                                      unloadingCost: e.unloadingCost,
                                      purchaseOrderItem: e.purchaseOrderItem,
                                      remark: e.remark,
                                      receivedQuantity: e.receivedQuantity,
                                    ))
                                .toList(),
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
              const Text('Create Material Receive')
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
