import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseDetailPage extends StatefulWidget {
  final String warehouseId;
  const WarehouseDetailPage({super.key, required this.warehouseId});
  @override
  State<WarehouseDetailPage> createState() => _WarehouseDetailPageState();
}

class _WarehouseDetailPageState extends State<WarehouseDetailPage> {
  @override
  void initState() {
    super.initState();

    context.read<WarehouseBloc>().add(const GetWarehousesEvent());

    context.read<ProductBloc>().add(
          GetWarehouseProducts(
            getProductsInputEntity: GetWarehouseProductsInputEntity(
              filterWarehouseProductInput:
                  FilterWarehouseProductInput(warehouseId: widget.warehouseId),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warehouse Details"),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              BlocBuilder<WarehouseBloc, WarehouseState>(builder: (_, state) {
                if (state is WarehousesLoading || state is WarehouseInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WarehousesSuccess) {
                  // Find warehouse by ID
                  final warehouse = state.warehouses!
                      .firstWhere((wh) => wh.id == widget.warehouseId);
                  return buildMaterialIssueInfo(context, warehouse);
                }
                if (state is WarehousesFailed) {
                  return Text(state.error!.errorMessage);
                }
                return const SizedBox();
              }),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is WarehouseProductsLoading ||
                        state is ProductInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is WarehouseProductsSuccess) {
                      if (state.warehouseProducts != null) {
                        return buildMaterialIssueMaterialsList(
                            context, state.warehouseProducts);
                      } else {
                        return const Center(
                            child: Text("No products available"));
                      }
                    }
                    if (state is WarehouseProductsFailed) {
                      return Text(state.error!.errorMessage);
                    }
                    return const SizedBox();
                  },
                ),
              )
            ],
          )),
    );
  }
}

Widget buildMaterialIssueInfo(BuildContext context, warehouse) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Warehouse Info",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const Expanded(
            child: Divider(),
          )
        ],
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TransactionInfoItem(title: 'Name', value: warehouse?.name ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Location', value: warehouse?.location ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Manager', value: warehouse?.name ?? 'N/A'),
          ],
        ),
      ),
    ],
  );
}

Widget buildMaterialIssueMaterialsList(
    BuildContext context, warehouseProducts) {
  return Expanded(
      child: Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Materials",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const Expanded(
            child: Divider(),
          )
        ],
      ),
      const SizedBox(height: 24),
      Expanded(
        child: ListView.builder(
          itemCount: warehouseProducts?.length,
          itemBuilder: (context, index) {
            final warehouseProduct = warehouseProducts[index];
            final productVariant = warehouseProduct.productVariant;
            return MaterialTransactionMaterialItem(
              title:
                  '${productVariant?.product?.name} - ${productVariant?.variant}',
              subtitle:
                  'Quantity: ${warehouseProduct.quantity} ${unitOfMeasureDisplay(productVariant?.unitOfMeasure)}',
              iconSrc: 'assets/icons/transactions/light/material_issues.svg',
              onDelete: () {},
              onEdit: () {},
              onOpen: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Wrap(children: [
                      Column(
                        children: [
                          ProductDetail(
                              title: "Material",
                              value:
                                  '${productVariant?.product?.name} - ${productVariant?.variant}'),
                          const SizedBox(
                            height: 10,
                          ),
                          ProductDetail(
                              title: "Unit",
                              value: unitOfMeasureDisplay(
                                  productVariant?.unitOfMeasure)),
                          const SizedBox(
                            height: 10,
                          ),
                          ProductDetail(
                              title: "Quantity",
                              value: warehouseProduct.quantity.toString()),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  ));
}
