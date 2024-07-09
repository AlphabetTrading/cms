import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/utils/ids.dart';

import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/daily_site_data/daily_site_data_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/daily_site_data_form/daily_site_data_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/daily_site_data_form/daily_site_data_form_state.dart';
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

class DailySiteDataCreatePage extends StatefulWidget {
  const DailySiteDataCreatePage({super.key});

  @override
  State<DailySiteDataCreatePage> createState() =>
      _DailySiteDataCreatePageState();
}

class _DailySiteDataCreatePageState extends State<DailySiteDataCreatePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(const GetWarehousesEvent());
  }

  // final String savedUserId = await GQLClient.getUserIdFromStorage();

  _buildOnCreateSuccess(BuildContext context) {
    // context.goNamed(RouteNames.dailySiteData);
    BlocProvider.of<DailySiteDataLocalBloc>(context)
        .add(const ClearDailySiteDataMaterialsLocal());
    context.pop();
    Fluttertoast.showToast(
        msg: "Material Issue Created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);

    context.read<DailySiteDataBloc>().add(
          GetDailySiteDatas(
            filterDailySiteDataInput: FilterDailySiteDataInput(),
            orderBy: OrderByDailySiteDataInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 20),
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
    // final dailySiteDataFormCubit = context.watch<DailySiteDataFormCubit>();
    // final warehouseDropdown = dailySiteDataFormCubit.state.warehouseDropdown;
    return BlocProvider(
      create: (context) => DailySiteDataWarehouseFormCubit(),
      child: BlocBuilder<DailySiteDataLocalBloc, DailySiteDataLocalState>(
        builder: (localContext, localState) {
          return BlocBuilder<DailySiteDataWarehouseFormCubit,
                  DailySiteDataWarehouseFormState>(
              builder: (warehouseFormContext, warehouseFormState) {
            return BlocConsumer<DailySiteDataBloc, DailySiteDataState>(
              listener: (issueContext, issueState) {
                debugPrint("Material Issue Create Page: $issueState");
                if (issueState is CreateDailySiteDataSuccess) {
                  _buildOnCreateSuccess(issueContext);
                } else if (issueState is CreateDailySiteDataFailed) {
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
                                .watch<DailySiteDataWarehouseFormCubit>();

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
                                  // (localState.dailySiteDataMaterials == null ||
                                  //         localState
                                  //             .dailySiteDataMaterials!.isEmpty)
                                  //     SizedBox.shrink(),
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
    DailySiteDataLocalState localState,
    DailySiteDataState state,
    DailySiteDataWarehouseFormState warehouseFormState,
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
                        .read<DailySiteDataWarehouseFormCubit>(),
                  ),
                  BlocProvider<DailySiteDataFormCubit>(
                    create: (_) => DailySiteDataFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
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
          onPressed: (state is CreateDailySiteDataLoading ||
                  localState.dailySiteDataMaterials == null ||
                  localState.dailySiteDataMaterials!.isEmpty)
              ? null
              : () {
                  context.read<DailySiteDataBloc>().add(
                        CreateDailySiteDataEvent(
                          createDailySiteDataParamsEntity:
                              CreateDailySiteDataParamsEntity(
                            projectId: context
                                    .read<ProjectBloc>()
                                    .state
                                    .selectedProjectId ??
                                "",
                            preparedById:
                                context.read<AuthBloc>().state.user?.id ??
                                    USER_ID,
                            tasks: [],
                          ),
                        ),
                      );

                  context.read<DailySiteDataBloc>().add(
                        GetDailySiteDatas(
                          filterDailySiteDataInput: FilterDailySiteDataInput(),
                          orderBy: OrderByDailySiteDataInput(createdAt: "desc"),
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
              state is CreateDailySiteDataLoading
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
