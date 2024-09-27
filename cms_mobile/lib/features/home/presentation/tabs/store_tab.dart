import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/warehouse/data/data_source/remote_data_source.dart';
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
            Expanded(
              child: BlocBuilder<WarehouseBloc, WarehouseState>(
                  builder: (context, state) {
                if (state is WarehousesLoading || state is WarehouseInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WarehousesFailed) {
                  return Text(state.error!.errorMessage);
                }
                if (state is WarehousesSuccess) {
                  return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: state.warehouses!.length,
                              separatorBuilder: (_, index) => const SizedBox(
                                height: 15,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  width: MediaQuery.of(context).size.width - 20,
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    color: const Color(0x110F4A84),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            state.warehouses?[index].name ??
                                                'N/A',
                                            style: const TextStyle(
                                              color: Color(0xFF111416),
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          PopupMenuButton(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry>[
                                              PopupMenuItem(
                                                  onTap: () {},
                                                  child: const ListTile(
                                                    leading: Icon(Icons.edit,
                                                        color: Colors.blue),
                                                    title: Text('Edit',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blue)),
                                                  )),
                                              PopupMenuItem(
                                                onTap: () {},
                                                child: const ListTile(
                                                  leading: Icon(Icons.delete,
                                                      color: Colors.red),
                                                  title: Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(state.warehouses?[index]
                                                  .location ??
                                              'N/A'),
                                          TextButton(
                                            onPressed: () {
                                              context.goNamed(
                                                  RouteNames.warehouseDetails,
                                                  pathParameters: {
                                                    "warehouseId": state
                                                        .warehouses![index].id,
                                                  });
                                            },
                                            child: const Text(
                                              'View Details',
                                              style: TextStyle(
                                                color: Color(0xFF1A80E5),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 0.17,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ));
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
            )
          ],
        ),
      ),
    );
  }
}
