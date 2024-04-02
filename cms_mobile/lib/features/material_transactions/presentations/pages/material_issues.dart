import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class MaterialIssuesPage extends StatefulWidget {
  const MaterialIssuesPage({Key? key}) : super(key: key);

  @override
  State<MaterialIssuesPage> createState() => _MaterialIssuesPageState();
}

class _MaterialIssuesPageState extends State<MaterialIssuesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MaterialIssueBloc>().add(
          GetMaterialIssues(
            orderBy: OrderByMaterialIssueInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 10),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = BehaviorSubject<String>();
    searchQuery.stream
        .debounceTime(const Duration(milliseconds: 500), )
        .listen((query, ) {
      context.read<MaterialIssueBloc>().add(
            GetMaterialIssues(
                orderBy: OrderByMaterialIssueInput(createdAt: "desc"),
                paginationInput: PaginationInput(skip: 0, take: 10),
                filterMaterialIssueInput: FilterMaterialIssueInput(
                  preparedBy: StringFilter(contains: query),
                  approvedBy: StringFilter(contains: query),
                  issuedTo: StringFilter(contains: query),
                  receivedBy: StringFilter(contains: query),
                  serialNumber: StringFilter(contains: query),
                )),
          );
    });

    return Scaffold(
      appBar: _buildAppbar(context),
      body: Container(
        padding: const EdgeInsets.all(10),
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
                  icon: const Icon(Icons.filter),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Material Issues'),
    );
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<MaterialIssueBloc, MaterialIssueState>(
      builder: (_, state) {
        debugPrint('MaterialRequestBlocBuilder state: $state');
        if (state is MaterialIssueInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MaterialIssueLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MaterialIssueSuccess) {
          debugPrint('MaterialRequestSuccess ${state.materialIssues?.items.length} ');

          return state.materialIssues!.items.isNotEmpty
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
                            itemCount: state.materialIssues!.items.length,
                            separatorBuilder: (_, index) => const SizedBox(
                              height: 10,
                            ),
                            itemBuilder: (_, index) {
                              final materialIssue =
                                  state.materialIssues!.items[index];
                              return _buildIssueListItem(
                                  context, materialIssue);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text('No Material Issues'),
                );
        }

        if (state is MaterialIssueFailed) {
          return Center(
            child: Text(state.error!.errorMessage),
          );
        }

        return const SizedBox();
      },
    );
  }

  _buildIssueListItem(BuildContext context, MaterialIssueEntity materialIssue) {
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
              const Text(
                'MRQ-001',
                style: TextStyle(
                  color: Color(0xFF111416),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF111416),
                ),
              ),
            ],
          ),
          const Text(
            '10/02/2024',
            style: TextStyle(
              color: Color(0xFF637587),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            'By Alula Tadesse',
            style: TextStyle(
              color: Color(0xFF111416),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
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
                  color: const Color(0x19FFB700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    color: Color(0xFFFFB700),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Text(
                'View Details',
                style: TextStyle(
                  color: Color(0xFF1A80E5),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0.17,
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
        return CustomPopupMenuDialog();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class CustomPopupMenuDialog extends StatefulWidget {
  @override
  State<CustomPopupMenuDialog> createState() => _CustomPopupMenuDialogState();
}

class _CustomPopupMenuDialogState extends State<CustomPopupMenuDialog> {
  final List<String> _projects = ['Bulbula', '24', 'Kazanchis'];

  // selected project index
  int _selectedProjectIndex = 0;

  void _onProjectSelected(int index) {
    setState(() {
      _selectedProjectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.grey[300],
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Projects',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: _projects.map((project) {
                      bool selected =
                          _projects.indexOf(project) == _selectedProjectIndex;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color: selected ? Theme.of(context).colorScheme.surfaceVariant : Theme.of(context).colorScheme.surface,
                        ),
                        child: ListTile(
                          onTap: () {
                            _onProjectSelected(_projects.indexOf(project));
                          },
                          selected: selected,
                          selectedTileColor: Colors.grey[300],
                          leading: CircleAvatar(
                              radius: 15,
                              child:
                                  Text(project.substring(0, 1).toUpperCase())),
                          title: Text(
                            project.toUpperCase(),
                            // style: const TextStyle(
                            //     fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          trailing: selected
                              ? const Icon(Icons.check)
                              : const SizedBox.shrink(),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
