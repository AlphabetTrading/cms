import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/create/create_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_proforma_form/material_proforma_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_proforma_form/material_proforma_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/empty_list.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_proforma/material_proforma_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_proforma/material_proforma_input_list.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class CreateMaterialProformaPage extends StatefulWidget {
  const CreateMaterialProformaPage({super.key});

  @override
  State<CreateMaterialProformaPage> createState() =>
      _CreateMaterialProformaPageState();
}

class _CreateMaterialProformaPageState
    extends State<CreateMaterialProformaPage> {
  List<MaterialProformaMaterialEntity> materialProformaMaterials = [];
  MaterialRequestItem? selectedRequestedMaterial;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MaterialRequestBloc>(context)
        .add(const GetMaterialRequestEvent());
  }

  void _addProformaItem(MaterialProformaMaterialEntity item) {
    setState(() {
      materialProformaMaterials.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final materialReturnFormCubit = context.watch<MaterialReturnFormCubit>();
    // final warehouseDropdown = materialReturnFormCubit.state.warehouseDropdown;
    return MultiBlocProvider(
        providers: [
          BlocProvider<MaterialProformaMainFormCubit>(
            create: (context) => MaterialProformaMainFormCubit(),
          ),
          BlocProvider<CreateMaterialProformaCubit>(
            create: (context) => sl<CreateMaterialProformaCubit>(),
          ),
        ],
        child: BlocBuilder<MaterialProformaMainFormCubit,
                MaterialProformaMainFormState>(
            builder: (proformaMainFormContext, proformaMainFormState) {
          return BlocConsumer<CreateMaterialProformaCubit,
              CreateMaterialProformaState>(
            listener: (createProformaContext, createProformaState) {
              if (createProformaState is CreateMaterialProformaSuccess) {
                context.goNamed(RouteNames.materialProforma);
                showStatusMessage(Status.SUCCESS, "Proforma Created");
              } else if (createProformaState is CreateMaterialProformaFailed) {
                showStatusMessage(Status.FAILED, createProformaState.error);
              }
            },
            builder: (createProformaContext, createProformaState) {
              final proformaMainFormCubit =
                  proformaMainFormContext.read<MaterialProformaMainFormCubit>();
              final materialRequestDropdown =
                  proformaMainFormState.materialRequestDropdown;
              final materialDropdown = proformaMainFormState.materialDropdown;

              return Scaffold(
                  appBar: AppBar(title: const Text("Create Material Proforma")),
                  bottomSheet: _buildButtons(createProformaContext,
                      createProformaState, proformaMainFormCubit),
                  body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<MaterialRequestBloc,
                          MaterialRequestState>(
                        builder:
                            (materialRequestContext, materialRequestState) {
                          List<MaterialRequestItem> requestedMaterials =
                              materialRequestDropdown.value != ""
                                  ? materialRequestState.materialRequests?.items
                                          .firstWhere((element) =>
                                              element.id ==
                                              materialRequestDropdown.value)
                                          .items ??
                                      []
                                  : [];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                CustomDropdown(
                                  onSelected: (dynamic value) {
                                    proformaMainFormCubit
                                        .materialRequestChanged(value);
                                  },
                                  dropdownMenuEntries: materialRequestState
                                          .materialRequests?.items
                                          .map((e) => DropdownMenuEntry<
                                                  MaterialRequestEntity>(
                                              label: e.serialNumber ?? "N/A",
                                              value: e))
                                          .toList() ??
                                      [],
                                  enableFilter: false,
                                  errorMessage:
                                      materialRequestDropdown.errorMessage,
                                  label: 'Material Request',
                                  trailingIcon: materialRequestState
                                          is MaterialRequestLoading
                                      ? const CircularProgressIndicator()
                                      : null,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomDropdown(
                                  onSelected: (dynamic value) {
                                    proformaMainFormCubit
                                        .materialChanged(value);
                                    setState(() {
                                      selectedRequestedMaterial = value;
                                    });
                                  },
                                  dropdownMenuEntries: requestedMaterials
                                      .map((e) => DropdownMenuEntry<
                                              MaterialRequestItem>(
                                          label:
                                              "${e.productVariant?.product?.name} - ${e.productVariant?.variant}",
                                          value: e))
                                      .toList(),
                                  enableFilter: false,
                                  errorMessage: materialDropdown.errorMessage,
                                  label: 'Material',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Proforma list:",
                                  textAlign: TextAlign.start,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                (materialProformaMaterials.isEmpty)
                                    ? const EmptyList()
                                    : MaterialProformaInputList(
                                        materialProformaMaterials:
                                            materialProformaMaterials,
                                      )
                              ],
                            ),
                          );
                        },
                      )));
            },
          );
        }));
  }

  _buildButtons(BuildContext context, CreateMaterialProformaState state,
      MaterialProformaMainFormCubit proformaMainFrom) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        OutlinedButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: proformaMainFrom,
                  ),
                  BlocProvider<MaterialProformaItemFormCubit>(
                    create: (_) => MaterialProformaItemFormCubit(),
                  )
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: MaterialProformaFrom(
                        onAddItem: _addProformaItem,
                        selectedRequestedMaterial: selectedRequestedMaterial,
                      ),
                    )
                  ],
                )),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Add Proforma'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: (materialProformaMaterials.isEmpty || state is CreateMaterialProformaLoading)
              ? null
              : () {
                  proformaMainFrom.onSubmit();
                  if (proformaMainFrom.state.isValid) {
                        
                    context
                        .read<CreateMaterialProformaCubit>()
                        .onCreateMaterialProforma(
                            createMaterialProformaParamsEntity:
                                CreateMaterialProformaParamsEntity(
                                    materialRequestItemId: proformaMainFrom
                                        .state.materialDropdown.value,
                                    preparedById:
                                        context.read<AuthBloc>().state.userId ??
                                            "",
                                    projectId: context
                                            .read<ProjectBloc>()
                                            .state
                                            .selectedProjectId ??
                                        "",
                                    materialProformaMaterials:
                                        materialProformaMaterials));
                  }
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
              const Text('Create Proforma Request')
            ],
          ),
        )
      ]),
    );
  }
}

enum MaterialRequestDropdownError { invalid }

class MaterialRequestDropdown
    extends FormzInput<String, MaterialRequestDropdownError> {
  const MaterialRequestDropdown.pure([String value = '']) : super.pure(value);
  const MaterialRequestDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MaterialRequestDropdownError.invalid) {
      return 'Select a material request';
    }
    return null;
  }

  @override
  MaterialRequestDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return MaterialRequestDropdownError.invalid;
    }
    return null;
  }
}

enum MaterialDropdownError { invalid }

class MaterialDropdown extends FormzInput<String, MaterialDropdownError> {
  const MaterialDropdown.pure([String value = '']) : super.pure(value);
  const MaterialDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MaterialDropdownError.invalid) {
      return 'Select a material request';
    }
    return null;
  }

  @override
  MaterialDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return MaterialDropdownError.invalid;
    }
    return null;
  }
}
