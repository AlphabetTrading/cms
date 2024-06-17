import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issues/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_return/material_return_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

class MaterialReturnsPage extends StatefulWidget {
  const MaterialReturnsPage({Key? key}) : super(key: key);

  @override
  State<MaterialReturnsPage> createState() => _MaterialReturnsPageState();
}

class _MaterialReturnsPageState extends State<MaterialReturnsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MaterialReturnBloc>().add(
          GetMaterialReturns(
            filterMaterialReturnInput: FilterMaterialReturnInput(),
            orderBy: OrderByMaterialReturnInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 10),
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
      context.read<MaterialReturnBloc>().add(
            GetMaterialReturns(
              orderBy: OrderByMaterialReturnInput(createdAt: "desc"),
              paginationInput: PaginationInput(skip: 0, take: 10),
              filterMaterialReturnInput: FilterMaterialReturnInput(
                approvedBy: StringFilter(contains: query),
                serialNumber: StringFilter(contains: query),
              ),
            ),
          );
    });

    return Scaffold(
      appBar: _buildAppbar(context),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.goNamed(RouteNames.materialIssueCreate);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Create Material Return'),
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
                    "../../../../../assets/icons/common/filter.svg",
                    height: 25,
                    width: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _buildBody(context),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Material Return'),
    );
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<MaterialReturnBloc, MaterialReturnState>(
      builder: (_, state) {
        debugPrint('MaterialReturnBlocBuilder state: $state');
        if (state is MaterialReturnInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MaterialReturnLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MaterialReturnSuccess) {
          debugPrint(
              'MaterialReturnSuccess ${state.materialReturns?.items.length} ');

          return state.materialReturns!.items.isNotEmpty
              ? Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: state.materialReturns!.items.length,
                            separatorBuilder: (_, index) => const SizedBox(
                              height: 10,
                            ),
                            itemBuilder: (_, index) {
                              final materialReturn =
                                  state.materialReturns!.items[index];
                              return _buildRequestListItem(
                                  context, materialReturn);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text('No Material Requests found'),
                );
        }

        if (state is MaterialReturnFailed) {
          return Center(
            child: Text(state.error!.errorMessage),
          );
        }

        return const SizedBox();
      },
    );
  }

  _buildRequestListItem(
      BuildContext context, MaterialReturnEntity materialReturn) {
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
                materialReturn.serialNumber ?? 'N/A',
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
                  PopupMenuItem(
                      onTap: () {
                        context.goNamed(RouteNames.materialIssueEdit,
                            pathParameters: {
                              'materialIssueId': materialReturn.id.toString()
                            });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.edit, color: Colors.blue),
                        title:
                            Text('Edit', style: TextStyle(color: Colors.blue)),
                      )),
                  PopupMenuItem(
                    onTap: () {
                      print('Item 2');
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
            DateFormat.yMMMMd().format(materialReturn.createdAt),
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
                'By ${materialReturn.receivedBy?.fullName ?? 'N/A'}',
                style: const TextStyle(
                  color: Color(0xFF111416),
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                materialReturn.receivedById ?? 'N/A',
                style: const TextStyle(
                  color: Color(0xFF637587),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              //  Text(
              //   "From ${materialIssue.?.fullName ?? 'N/A'}",
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
                  color: materialReturn.status == MaterialReturnStatus.pending
                      ? const Color.fromARGB(31, 255, 183, 0)
                      : materialReturn.status == MaterialReturnStatus.approved
                          ? const Color.fromARGB(30, 0, 179, 66)
                          : materialReturn.status ==
                                  MaterialReturnStatus.declined
                              ? const Color.fromARGB(30, 208, 2, 26)
                              : const Color.fromARGB(31, 17, 20, 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  materialReturn.status.toString(),
                  style: TextStyle(
                    color: materialReturn.status == MaterialReturnStatus.pending
                        ? const Color(0xFFFFB700)
                        : materialReturn.status == MaterialReturnStatus.approved
                            ? const Color(0xFF00B341)
                            : materialReturn.status ==
                                    MaterialReturnStatus.declined
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
                  context.goNamed(RouteNames.materialReturnDetails,
                      pathParameters: {
                        'materialReturnId': materialReturn.id.toString()
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

  void _showCustomPopupMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const FilterPopupMenuDialog();
      },
    );
  }
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
    context.read<MaterialIssueBloc>().add(
          GetMaterialIssues(
            filterMaterialIssueInput: FilterMaterialIssueInput(
              status: selectedStatuses.contains('All')
                  ? null
                  : selectedStatuses
                      .map((status) => status.toUpperCase())
                      .toList(),
            ),
            orderBy: OrderByMaterialIssueInput(createdAt: "desc"),
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
                        "../../../../../assets/icons/common/filter.svg",
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
