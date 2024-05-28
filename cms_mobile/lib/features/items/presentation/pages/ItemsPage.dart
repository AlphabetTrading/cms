import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_bloc.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_event.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_state.dart';
import 'package:cms_mobile/features/items/presentation/widgets/item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsPage extends StatefulWidget {
  final String warehouseId;
  const ItemsPage({super.key, required this.warehouseId});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  @override
  void initState() {
    super.initState();

    context.read<ItemBloc>().add(
          GetWarehouseItems(
            getItemsInputEntity: GetWarehouseItemsInputEntity(
              filterWarehouseItemInput:
                  FilterWarehouseItemInput(warehouseId: widget.warehouseId),
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
        child: BlocBuilder<ItemBloc, ItemState>(builder: (_, state) {
          if (state is ItemInitial || state is WarehouseItemsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WarehouseItemsSuccess) {
            return ListView.builder(
                itemCount: state.warehouseItems!.length,
                itemBuilder: (context, index) {
                  return ItemTile(
                    warehouseItemEntity: state.warehouseItems![index],
                  );
                });
          }
          if (state is WarehouseItemsFailed) {
            return Text(state.error!.errorMessage);
          }
          return const SizedBox();
        }),
      ),
    );
  }
}
