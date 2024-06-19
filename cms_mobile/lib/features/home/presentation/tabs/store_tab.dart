import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_bloc.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_event.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StoreTabScreen extends StatefulWidget {
  const StoreTabScreen({super.key});

  @override
  State<StoreTabScreen> createState() => _StoreTabScreenState();
}
class _StoreTabScreenState extends State<StoreTabScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WarehouseBloc>().add(const GetWarehousesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warehouses',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 10),
            BlocBuilder<WarehouseBloc, WarehouseState>(
                builder: (context, state) {
              if (state is WarehousesLoading || state is WarehouseInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is WarehousesFailed) {
                return Text(state.error!.errorMessage);
              }
              if (state is WarehousesSuccess) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.warehouses!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        context.goNamed(
                          RouteNames.items,
                          pathParameters: {
                            "warehouseId": state.warehouses![index].id,
                          },
                        );
                      },
                      child: Container(
                        height: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: ShapeDecoration(
                          color: const Color(0x110F4A84),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            state.warehouses![index].name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text("72 Items"),
                          trailing: Text("View Details",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                        ),
                      ),
                    );
                  },
                );
              }
              return Container();
            }),
            // ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: items.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return InkWell(
            //       onTap: () => context.goNamed("materials"),
            //       child: Container(
            //         height: 80,
            //         alignment: Alignment.center,
            //         margin: const EdgeInsets.only(bottom: 10),
            //         decoration: ShapeDecoration(
            //           color: const Color(0x110F4A84),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),
            //         child: ListTile(
            //           title: Text(
            //             items[index],
            //             style: Theme.of(context).textTheme.bodyLarge,
            //           ),
            //           subtitle: Text("72 Items"),
            //           trailing: Text("View Details",
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .bodySmall
            //                   ?.copyWith(
            //                       color:
            //                           Theme.of(context).colorScheme.primary)),
            //         ),
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
