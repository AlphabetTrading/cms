import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse/warehouse_bloc.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_local/warehouse_local_bloc.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_local/warehouse_local_state.dart';
import 'package:cms_mobile/features/warehouse/presentation/cubit/warehouse_form/warehouse_form_cubit.dart';
import 'package:cms_mobile/features/warehouse/presentation/cubit/warehouse_form/warehouse_form_state.dart';
import 'package:cms_mobile/features/warehouse/presentation/widgets/create_warehouse_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  _buildOnCreateSuccess(BuildContext context) {
    context.pop();
    Fluttertoast.showToast(
        msg: "Warehouse Created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: const Color(0xFF018717),
        textColor: Colors.white,
        fontSize: 16.0);

    // Trigger fetching the updated list of warehouses
    context.read<WarehouseBloc>().add(const GetWarehousesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => WarehouseFormCubit(),
        child: BlocBuilder<WarehouseLocalBloc, WarehouseLocalState>(
            builder: (localContext, localState) {
          return BlocBuilder<WarehouseFormCubit, WarehouseFormState>(
              builder: (warehouseFormContext, warehouseFormState) {
            return BlocConsumer<WarehouseBloc, WarehouseState>(
                listener: (context, state) {
              if (state is CreateWarehouseSuccess) {
                _buildOnCreateSuccess(context);
              } else if (state is CreateWarehouseFailed) {
                Fluttertoast.showToast(
                    msg:
                        state.error?.errorMessage ?? "Error creating warehouse",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }, builder: (context, state) {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: warehouseFormContext.read<WarehouseFormCubit>(),
                            ),
                            BlocProvider<WarehouseFormCubit>(
                              create: (_) => WarehouseFormCubit(),
                            )
                          ],
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: CreateWarehouseForm(),
                              )
                            ],
                          )),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add),
                  ),
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
                            if (state is WarehousesLoading ||
                                state is WarehouseInitial) {
                              return const Center(
                                  child: CircularProgressIndicator());
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: state.warehouses!.length,
                                          separatorBuilder: (_, index) =>
                                              const SizedBox(
                                            height: 15,
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20,
                                              alignment: Alignment.center,
                                              decoration: ShapeDecoration(
                                                color: const Color(0x110F4A84),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        state.warehouses?[index]
                                                                .name ??
                                                            'N/A',
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF111416),
                                                          fontSize: 18,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      PopupMenuButton(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry>[
                                                          PopupMenuItem(
                                                              onTap: () {},
                                                              child:
                                                                  const ListTile(
                                                                leading: Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .blue),
                                                                title: Text(
                                                                    'Edit',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue)),
                                                              )),
                                                          PopupMenuItem(
                                                            onTap: () {},
                                                            child:
                                                                const ListTile(
                                                              leading: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red),
                                                              title: Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)),
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(state
                                                              .warehouses?[
                                                                  index]
                                                              .location ??
                                                          'N/A'),
                                                      TextButton(
                                                        onPressed: () {
                                                          context.goNamed(
                                                              RouteNames
                                                                  .warehouseDetails,
                                                              pathParameters: {
                                                                "warehouseId": state
                                                                        .warehouses![
                                                                            index]
                                                                        .id ??
                                                                    "",
                                                              });
                                                        },
                                                        child: const Text(
                                                          'View Details',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF1A80E5),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w500,
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
                        )
                      ],
                    ),
                  ));
            });
          });
        }));
  }
}
