import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/utils/ids.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_bloc.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_event.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_issue_form/material_issue_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_issue_form/material_issue_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_issue/create_material_issue_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_issue/material_issue_input_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class CreateMaterialIssuePage extends StatefulWidget {
  const CreateMaterialIssuePage({super.key});

  @override
  State<CreateMaterialIssuePage> createState() =>
      _CreateMaterialIssuePageState();
}

class _CreateMaterialIssuePageState extends State<CreateMaterialIssuePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  _buildOnCreateSuccess(BuildContext context) {
    context.goNamed(RouteNames.materialIssue);
    BlocProvider.of<MaterialIssueLocalBloc>(context)
        .add(const ClearMaterialIssueMaterialsLocal());
    Fluttertoast.showToast(
        msg: "Material Issue Created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);
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
    // final materialIssueFormCubit = context.watch<MaterialIssueFormCubit>();
    // final warehouseDropdown = materialIssueFormCubit.state.warehouseDropdown;
    return BlocProvider(
      create: (context) => MaterialIssueWarehouseFormCubit(),
      child: BlocBuilder<MaterialIssueLocalBloc, MaterialIssueLocalState>(
        builder: (localContext, localState) {
          return BlocBuilder<MaterialIssueWarehouseFormCubit,
                  MaterialIssueWarehouseFormState>(
              builder: (warehouseFormContext, warehouseFormState) {
            return BlocConsumer<MaterialIssueBloc, MaterialIssueState>(
              listener: (issueContext, issueState) {
                if (issueState is CreateMaterialIssueSuccess) {
                  _buildOnCreateSuccess(issueContext);
                } else if (issueState is CreateMaterialIssueFailed) {
                  _buildOnCreateFailed(issueContext);
                }
              },
              builder: (issueContext, issueState) {
                return Scaffold(
                    appBar: AppBar(),
                    bottomSheet: _buildButtons(
                        issueContext, localState, issueState, warehouseFormState,warehouseFormContext),
                    body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<WarehouseBloc, WarehouseState>(
                          builder: (warehouseContext, warehouseState) {
                            final warehouseForm = warehouseFormContext
                                .watch<MaterialIssueWarehouseFormCubit>();

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  CustomDropdown(
                                    onSelected: (dynamic value) {
                                      warehouseForm.warehouseChanged(value);
                                      context.read<ItemBloc>().add(
                                            GetWarehouseItems(
                                              getItemsInputEntity:
                                                  GetWarehouseItemsInputEntity(
                                                filterWarehouseItemInput:
                                                    FilterWarehouseItemInput(
                                                        warehouseId: value.id),
                                              ),
                                            ),
                                          );
                                    },
                                    dropdownMenuEntries: warehouseState.warehouses
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
                                    height: 10,
                                  ),
                                  (localState.materialIssueMaterials == null ||
                                          localState
                                              .materialIssueMaterials!.isEmpty)
                                      ? const EmptyList()
                                      : MaterialIssueInputList(
                                          materialIssues:
                                              localState.materialIssueMaterials!),
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
      MaterialIssueLocalState localState,
      MaterialIssueState state,
      MaterialIssueWarehouseFormState warehouseFormState,
      BuildContext warehouseFormContext,
      ) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        OutlinedButton(
          // onPressed:(){},
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: warehouseFormContext.read<MaterialIssueWarehouseFormCubit>(),
                  ),
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
          onPressed: (state is CreateMaterialIssueLoading ||
                  localState.materialIssueMaterials == null ||
                  localState.materialIssueMaterials!.isEmpty)
              ? null
              : () {
                  context.read<MaterialIssueBloc>().add(CreateMaterialIssueEvent(
                      createMaterialIssueParamsEntity:
                          CreateMaterialIssueParamsEntity(
                              projectId: PROJECT_ID,
                              preparedById: USER_ID,
                              // warehouseStoreId: "",
                              warehouseStoreId:
                                  warehouseFormState.warehouseDropdown.value,
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
                                      .toList())));
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is CreateMaterialIssueLoading
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
