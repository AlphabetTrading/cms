import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePurchaseOrderProforma extends StatefulWidget {
  const CreatePurchaseOrderProforma({super.key});

  @override
  _ProformaFormState createState() => _ProformaFormState();
}

class _ProformaFormState extends State<CreatePurchaseOrderProforma> {
  @override
  void initState() {
    super.initState();
    // Fetch the proformas using your BLoC
    BlocProvider.of<MaterialProformaBloc>(context)
        .add(const GetAllMaterialProformas(""));
  }

  @override
  Widget build(BuildContext context) {
    final purchaseOrderFormCubit = context.watch<PurchaseOrderFormCubit>();
    final proformaDropdown = purchaseOrderFormCubit.state.proformaDropdown;
    final remarkField = purchaseOrderFormCubit.state.remarkField;

    return BlocBuilder<MaterialProformaBloc, MaterialProformaState>(
      builder: (context, state) {
        if (state is AllMaterialProformasLoading) {
          return const CircularProgressIndicator();
        } else if (state is AllMaterialProformasSuccess) {
          return Column(
            children: [
              CustomDropdown(
                initialSelection: proformaDropdown.value,
                onSelected: (dynamic value) {
                  final selectedProforma =
                      state.allMaterialProformas?.firstWhere(
                    (proforma) => proforma.id == value,
                  );

                  if (selectedProforma != null) {
                    purchaseOrderFormCubit.proformaChanged(selectedProforma);
                  }
                },
                dropdownMenuEntries: state.allMaterialProformas
                        ?.map((e) => DropdownMenuEntry<String>(
                              label: e.serialNumber!,
                              value: e.id,
                            ))
                        .toList() ??
                    [],
                enableFilter: false,
                errorMessage: proformaDropdown.errorMessage,
                label: 'Proforma',
              ),
              const SizedBox(height: 10),
              if (proformaDropdown.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Approved proforma preview",
                          style: Theme.of(context).textTheme.labelSmall),
                      const Expanded(
                        child: Divider(),
                      )
                    ],
                  ),
                ),
              if (proformaDropdown.value.isNotEmpty)
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Vendor",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text(purchaseOrderFormCubit.state.vendor
                                  .toString()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Material",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text(
                                state.allMaterialProformas
                                        ?.firstWhere(
                                          (element) =>
                                              element.id ==
                                              proformaDropdown.value,
                                        )
                                        .materialRequestItem
                                        ?.productVariant
                                        ?.variant ??
                                    "N/A",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Quantity",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text(purchaseOrderFormCubit.state.quantity
                                  .toString()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Unit",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text(
                                state.allMaterialProformas
                                        ?.firstWhere(
                                          (element) =>
                                              element.id ==
                                              proformaDropdown.value,
                                        )
                                        .materialRequestItem
                                        ?.productVariant
                                        ?.unitOfMeasure
                                        ?.name ??
                                    "N/A",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Price per unit",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text(purchaseOrderFormCubit
                                  .state.unitPriceField.unitPrice
                                  .toString()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Price",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text(purchaseOrderFormCubit.state.totalPrice
                                  .toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              if (proformaDropdown.value.isNotEmpty)
                CustomTextFormField(
                  initialValue: remarkField.value,
                  label: "Remark",
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  onChanged: purchaseOrderFormCubit.remarkChanged,
                  errorMessage: remarkField.errorMessage,
                ),
              const SizedBox(
                height: 10,
              ), //
            ],
          );
        } else if (state is AllMaterialProformasFailed) {
          return const Text("Failed to load Proformas",
              style: TextStyle(color: Colors.red));
        }
        return Container(); // Empty state
      },
    );
  }
}
