import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/daily_site_data/daily_site_data_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/delete/delete_cubit.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

class DailySiteDatasPage extends StatefulWidget {
  const DailySiteDatasPage({super.key});

  @override
  State<DailySiteDatasPage> createState() => _DailySiteDatasPageState();
}

class _DailySiteDatasPageState extends State<DailySiteDatasPage> {
  bool selectedMineFilter = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<DailySiteDataBloc>().add(
          GetDailySiteDatas(
            filterDailySiteDataInput: FilterDailySiteDataInput(),
            orderBy: OrderByDailySiteDataInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 20),
            mine: false,
          ),
        );

    // read auth state
    debugPrint("Auth state: ${context.read<AuthBloc>().state.userId}");
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = BehaviorSubject<String>();

    searchQuery.stream
        .debounceTime(
      const Duration(milliseconds: 500),
    )
        .listen((
      query,
    ) {
      context.read<DailySiteDataBloc>().add(
            GetDailySiteDatas(
                orderBy: OrderByDailySiteDataInput(createdAt: "desc"),
                paginationInput: PaginationInput(skip: 0, take: 10),
                filterDailySiteDataInput: FilterDailySiteDataInput(
                  preparedBy: StringFilter(contains: query),
                  approvedBy: StringFilter(contains: query),
                  serialNumber: StringFilter(contains: query),
                )),
          );
    });

    return Scaffold(
      appBar: _buildAppbar(context),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.goNamed(RouteNames.dailySiteDataCreate);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Create Daily Site Data'),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (query) {
                        debugPrint('Search query: $query');
                        searchQuery.add(query);
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showCustomPopupMenu(context);
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/common/filter.svg",
                    height: 25,
                    width: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // toggle button for filter all, and my issues
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ToggleButtons(
                    onPressed: (index) {
                      setState(() {
                        debugPrint("Selected index: $index");
                        if (index == 0) {
                          selectedMineFilter = false;
                        } else if (index == 1) {
                          selectedMineFilter = true;
                        }

                        context.read<DailySiteDataBloc>().add(
                              GetDailySiteDatas(
                                filterDailySiteDataInput:
                                    FilterDailySiteDataInput(),
                                orderBy: OrderByDailySiteDataInput(
                                    createdAt: "desc"),
                                paginationInput:
                                    PaginationInput(skip: 0, take: 20),
                                mine: selectedMineFilter,
                              ),
                            );
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 100.0,
                    ),
                    isSelected: [
                      !selectedMineFilter,
                      selectedMineFilter
                    ],
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('All'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Mine', style: TextStyle(fontSize: 12)),
                      ),
                    ]),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _buildBody(context, selectedMineFilter),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<DailySiteDataBloc>().add(GetDailySiteDatas(
            filterDailySiteDataInput: FilterDailySiteDataInput(),
            orderBy: OrderByDailySiteDataInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 20),
            mine: selectedMineFilter,
          ));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Daily Site Data'),
    );
  }

  _buildBody(BuildContext context, bool selectedMineFilter) {
    return selectedMineFilter
        ? BlocBuilder<DailySiteDataBloc, DailySiteDataState>(
            builder: (context, state) {
              debugPrint('MaterialRequestBlocBuilder state: $state');
              if (state is DailySiteDataInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is DailySiteDatasLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is DailySiteDatasSuccess) {
                return state.myDailySiteDatas!.items.isNotEmpty
                    ? BlocProvider<DeleteDailySiteDataCubit>(
                        create: (context) => sl<DeleteDailySiteDataCubit>(),
                        child: Expanded(
                          child: BlocListener<DeleteDailySiteDataCubit,
                              DeleteDailySiteDataState>(
                            listener: (context, state) {
                              if (state is DeleteDailySiteDataSuccess) {
                                context
                                    .read<DailySiteDataBloc>()
                                    .add(DeleteDailySiteDataEventLocal(
                                      isMine: selectedMineFilter,
                                      dailySiteDataId: state.dailySiteDataId,
                                    )
                                        // GetDailySiteDatas(
                                        //   filterDailySiteDataInput:
                                        //       FilterDailySiteDataInput(),
                                        //   orderBy: OrderByDailySiteDataInput(
                                        //       createdAt: "desc"),
                                        //   paginationInput:
                                        //       PaginationInput(skip: 0, take: 20),
                                        //   mine: selectedMineFilter,
                                        // ),
                                        );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          state.myDailySiteDatas!.items.length,
                                      separatorBuilder: (_, index) =>
                                          const SizedBox(
                                        height: 10,
                                      ),
                                      itemBuilder: (_, index) {
                                        final dailySiteData = state
                                            .myDailySiteDatas!.items[index];
                                        return _buildIssueListItem(
                                            context, dailySiteData);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    : const Center(
                        child: Text('No Daily Site Data'),
                      );
              }

              if (state is DailySiteDatasFailed) {
                return Center(
                  child: Text(state.error!.errorMessage),
                );
              }

              return const SizedBox();
            },
          )
        : (BlocProvider<DeleteDailySiteDataCubit>(
            create: (context) => sl<DeleteDailySiteDataCubit>(),
            child: BlocBuilder<DailySiteDataBloc, DailySiteDataState>(
              builder: (_, state) {
                debugPrint('MaterialRequestBlocBuilder state: $state');
                if (state is DailySiteDataInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is DailySiteDatasLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is DailySiteDatasSuccess) {
                  debugPrint(
                      'MaterialRequestSuccess ${state.dailySiteDatas?.items.length} ');

                  return state.dailySiteDatas!.items.isNotEmpty
                      ? Expanded(
                          child: BlocListener<DeleteDailySiteDataCubit,
                              DeleteDailySiteDataState>(
                            listener: (context, state) {
                              if (state is DeleteDailySiteDataSuccess) {
                                context.read<DailySiteDataBloc>().add(
                                      GetDailySiteDatas(
                                        filterDailySiteDataInput:
                                            FilterDailySiteDataInput(),
                                        orderBy: OrderByDailySiteDataInput(
                                            createdAt: "desc"),
                                        paginationInput:
                                            PaginationInput(skip: 0, take: 20),
                                        mine: selectedMineFilter,
                                      ),
                                    );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          state.dailySiteDatas!.items.length,
                                      separatorBuilder: (_, index) =>
                                          const SizedBox(
                                        height: 10,
                                      ),
                                      itemBuilder: (_, index) {
                                        final dailySiteData =
                                            state.dailySiteDatas!.items[index];
                                        return _buildIssueListItem(
                                            context, dailySiteData);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text('No Daily Site Data'),
                        );
                }

                if (state is DailySiteDatasFailed) {
                  return Center(
                    child: Text(state.error!.errorMessage),
                  );
                }

                return const SizedBox();
              },
            ),
          ));
  }

  _buildIssueListItem(BuildContext context, DailySiteDataEntity dailySiteData) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: ShapeDecoration(
        color: const Color(0x110F4A84),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                dailySiteData.preparedBy?.fullName ?? 'N/A',
                style: const TextStyle(
                  color: Color(0xFF111416),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              PopupMenuButton(
                color: Theme.of(context).colorScheme.surface,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  // PopupMenuItem(
                  //     onTap: () {
                  //       context.goNamed(RouteNames.dailySiteDataEdit,
                  //           pathParameters: {
                  //             'dailySiteDataId': dailySiteData.id.toString()
                  //           });
                  //     },
                  //     child: const ListTile(
                  //       leading: Icon(Icons.edit, color: Colors.blue),
                  //       title:
                  //           Text('Edit', style: TextStyle(color: Colors.blue)),
                  //     )),
                  PopupMenuItem(
                    onTap: () {
                      context
                          .read<DeleteDailySiteDataCubit>()
                          .onDailySiteDataDelete(
                              dailySiteDataId: dailySiteData.id ?? "");
                    },
                    child: const ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            DateFormat.yMMMMd().format(dailySiteData.createdAt!),
            style: const TextStyle(
              color: Color(0xFF637587),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'By ${dailySiteData.preparedBy?.fullName ?? 'N/A'}',
                style: const TextStyle(
                  color: Color(0xFF111416),
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                dailySiteData.preparedBy?.email ?? 'N/A',
                style: const TextStyle(
                  color: Color(0xFF637587),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              //  Text(
              //   "From ${dailySiteData.?.fullName ?? 'N/A'}",
              //   style: const TextStyle(
              //     color: Color(0xFF637587),
              //     fontSize: 12,
              //     fontFamily: 'Inter',
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: ShapeDecoration(
                  color: dailySiteData.status == 'PENDING'
                      ? const Color.fromARGB(31, 255, 183, 0)
                      : dailySiteData.status == 'COMPLETED'
                          ? const Color.fromARGB(30, 0, 179, 66)
                          : dailySiteData.status == 'DECLINED'
                              ? const Color.fromARGB(30, 208, 2, 26)
                              : const Color.fromARGB(31, 17, 20, 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  dailySiteData.status ?? 'N/A',
                  style: TextStyle(
                    color: dailySiteData.status == 'PENDING'
                        ? const Color(0xFFFFB700)
                        : dailySiteData.status == 'COMPLETED'
                            ? const Color(0xFF00B341)
                            : dailySiteData.status == 'DECLINED'
                                ? const Color(0xFFD0021B)
                                : const Color(0xFF111416),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.goNamed(RouteNames.dailySiteDataDetails,
                      pathParameters: {
                        'dailySiteDataId': dailySiteData.id.toString()
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
  }
}

void _showCustomPopupMenu(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const FilterPopupMenuDialog();
    },
  );
}

class FilterPopupMenuDialog extends StatefulWidget {
  const FilterPopupMenuDialog({super.key});

  @override
  State<FilterPopupMenuDialog> createState() => _CustomPopupMenuDialogState();
}

class _CustomPopupMenuDialogState extends State<FilterPopupMenuDialog> {
  final List<String> statuses = ['All', 'Pending', 'Completed', 'Declined'];
  List<String> selectedStatuses = [];

  void _onStatusSelected() {
    context.read<DailySiteDataBloc>().add(
          GetDailySiteDatas(
            filterDailySiteDataInput: FilterDailySiteDataInput(
              status: selectedStatuses.contains('All')
                  ? null
                  : selectedStatuses
                      .map((status) => status.toUpperCase())
                      .toList(),
            ),
            orderBy: OrderByDailySiteDataInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 10),
          ),
        );
    Navigator.pop(context);
  }

  void _onFilterChange(value, index) {
    setState(() {
      if (statuses[index] == 'All') {
        if (value == true) {
          selectedStatuses = [...statuses];
        } else {
          selectedStatuses = [];
        }
      } else {
        if (value == true) {
          selectedStatuses.add(statuses[index]);
        } else {
          if (statuses.contains('All')) {
            selectedStatuses.remove('All');
          }
          selectedStatuses.remove(statuses[index]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      // backgroundColor: Colors.grey[300],
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      content: Container(
        width: MediaQuery.of(context).size.width *
            0.8, // Set width as 80% of screen width
        padding: const EdgeInsets.all(16.0),

        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/common/filter.svg",
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Filter',
                        style: TextStyle(
                          color: Color(0xFF637587),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Color(0xFFE5E5E5),
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF111416),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    onTap: () {
                      _onFilterChange(
                          !selectedStatuses.contains(statuses[index]), index);
                    },
                    title: Text(
                      statuses[index],
                      style: const TextStyle(
                        color: Color(0xFF111416),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Checkbox(
                        value: selectedStatuses.contains(statuses[index]),
                        onChanged: (value) => _onFilterChange(value, index)),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 1,
                  );
                },
                itemCount: statuses.length,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Color(0xFFE5E5E5),
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          _onStatusSelected();
                        },
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
