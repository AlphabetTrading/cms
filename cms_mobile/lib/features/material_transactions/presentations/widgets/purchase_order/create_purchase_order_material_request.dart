import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePurchaseOrderMaterialRequestForm extends StatefulWidget {
  const CreatePurchaseOrderMaterialRequestForm({super.key});

  @override
  _MaterialRequestFormState createState() => _MaterialRequestFormState();
}

class _MaterialRequestFormState
    extends State<CreatePurchaseOrderMaterialRequestForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MaterialRequestBloc>(context)
        .add(const GetMaterialRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    final purchaseOrderFormCubit = context.watch<PurchaseOrderFormCubit>();
    final materialRequestDropdown =
        purchaseOrderFormCubit.state.materialRequestDropdown;
    final materialRequestItemDropdown =
        purchaseOrderFormCubit.state.materialRequestItemDropdown;
    final unitPriceField = purchaseOrderFormCubit.state.unitPriceField;
    final remarkField = purchaseOrderFormCubit.state.remarkField;

    return BlocBuilder<MaterialRequestBloc, MaterialRequestState>(
      builder: (context, state) {
        if (state is MaterialRequestLoading) {
          return const CircularProgressIndicator();
        } else if (state is MaterialRequestSuccess) {
          return Column(
            children: [
              CustomDropdown(
                initialSelection: materialRequestDropdown.value,
                onSelected: (dynamic value) {
                  final selectedMaterialRequest =
                      state.materialRequests?.items.firstWhere(
                    (request) => request.id == value,
                  );

                  if (selectedMaterialRequest != null) {
                    purchaseOrderFormCubit
                        .materialRequestChanged(selectedMaterialRequest);
                  }
                },
                dropdownMenuEntries: state.materialRequests?.items
                        .map((e) => DropdownMenuEntry<String>(
                              label: e.serialNumber!,
                              value: e.id!,
                            ))
                        .toList() ??
                    [],
                enableFilter: false,
                errorMessage: materialRequestDropdown.errorMessage,
                label: 'Material Request',
              ),
              const SizedBox(height: 10),
              if (materialRequestDropdown.value.isNotEmpty)
                CustomDropdown(
                  initialSelection: materialRequestItemDropdown.value,
                  onSelected: (dynamic value) {
                    final selectedItem = purchaseOrderFormCubit
                        .state.selectedMaterialRequest?.items
                        ?.firstWhere(
                      (item) => item.id == value,
                    );

                    if (selectedItem != null) {
                      purchaseOrderFormCubit
                          .materialRequestItemChanged(selectedItem);
                    }
                  },
                  dropdownMenuEntries: purchaseOrderFormCubit
                          .state.selectedMaterialRequest?.items
                          ?.map((e) => DropdownMenuEntry<String>(
                                label: e.productVariant?.variant! ?? "",
                                value: e.id!,
                              ))
                          .toList() ??
                      [],
                  enableFilter: false,
                  errorMessage: materialRequestDropdown.errorMessage,
                  label: 'Material',
                ),
              const SizedBox(height: 10),
              if (materialRequestDropdown.value.isNotEmpty &&
                  materialRequestItemDropdown.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Material Request preview",
                          style: Theme.of(context).textTheme.labelSmall),
                      const Expanded(
                        child: Divider(),
                      )
                    ],
                  ),
                ),
              if (materialRequestDropdown.value.isNotEmpty &&
                  materialRequestItemDropdown.value.isNotEmpty)
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Unit",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text(
                                purchaseOrderFormCubit
                                        .state.selectedMaterialRequest?.items
                                        ?.firstWhere(
                                          (element) {
                                            print(
                                                'Element: ${element.productVariantId}');
                                            return element.id ==
                                                materialRequestItemDropdown
                                                    .value;
                                          },
                                          orElse: () => MaterialRequestItem(),
                                        )
                                        .productVariant
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: CustomTextFormField(
                            initialValue:
                                double.tryParse(unitPriceField.value) != null
                                    ? unitPriceField.value
                                    : "",
                            keyboardType: TextInputType.number,
                            label: "Unit Price",
                            onChanged: purchaseOrderFormCubit.unitPriceChanged,
                            errorMessage: unitPriceField.errorMessage,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
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
              if (materialRequestDropdown.value.isNotEmpty &&
                  materialRequestItemDropdown.value.isNotEmpty)
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
        } else if (state is MaterialRequestFailed) {
          return const Text("Failed to load Material Requests",
              style: TextStyle(color: Colors.red));
        }
        return Container();
      },
    );
  }
}
