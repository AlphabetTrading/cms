import 'package:cms_mobile/features/products/domain/entities/get_products_input.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsPage extends StatefulWidget {
  final String warehouseId;
  const ProductsPage({super.key, required this.warehouseId});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();

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
        title: const Text("Materials List"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: BlocBuilder<ProductBloc, ProductState>(builder: (_, state) {
          if (state is ProductInitial || state is WarehouseProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WarehouseProductsSuccess) {
            return ListView.builder(
                itemCount: state.warehouseProducts!.length,
                itemBuilder: (context, index) {
                  return ProductTile(
                    warehouseProductEntity: state.warehouseProducts![index],
                  );
                });
          }
          if (state is WarehouseProductsFailed) {
            return Text(state.error!.errorMessage);
          }
          return const SizedBox();
        }),
      ),
    );
  }
}
