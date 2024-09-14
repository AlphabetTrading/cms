import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/projects/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_event.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_state.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:cms_mobile/features/theme/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomPopupMenuDialog extends StatefulWidget {
  const CustomPopupMenuDialog({super.key});

  @override
  State<CustomPopupMenuDialog> createState() => _CustomPopupMenuDialogState();
}

class _CustomPopupMenuDialogState extends State<CustomPopupMenuDialog> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(
          GetProjects(
              paginationInput: PaginationInput(skip: 0, take: 10),
              orderBy: OrderByProjectInput(createdAt: "desc")),
        );

    // context.read<ProjectBloc>().add(SelectProject(
    //     context.read<ProjectBloc>().state.selectedProjectId!,
    //     context.read<ProjectBloc>().state.projects!));
  }

  void _onProjectSelected(String id) {
    context.read<ProjectBloc>().add(
          SelectProject(
            id,
            context.read<ProjectBloc>().state.projects!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.grey[300],
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      clipBehavior: Clip.antiAlias,
      child: BlocBuilder<ProjectBloc, ProjectState>(builder: (context, state) {
        if (state is ProjectLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ProjectFailed) {
          return Center(
            child: Text(state.error.toString()),
          );
        }

        if (state is ProjectEmpty) {
          return const Center(
            child: Text('No Projects Found'),
          );
        }

        // if (state is ProjectSelected || state is ProjectSuccess) {
        if (state is ProjectStateWithMeta || state is ProjectSuccess) {
          debugPrint('state: $state');
          ProjectEntityListWithMeta projects;
          if (state is ProjectStateWithMeta) {
            projects = state.projects!;

            debugPrint(
                'projectss: $projects, selected project ${state.selectedProjectId}');
          } else {
            projects = context.read<ProjectBloc>().state.projects!;
            debugPrint('projects: $projects');
          }

          return Container(
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
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                      const SizedBox(
                        height: 20,
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: projects.items.map((project) {
                          bool selected = state is ProjectStateWithMeta &&
                              state.selectedProjectId == project.id;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: selected ? Theme.of(context).colorScheme.surfaceVariant : Theme.of(context).colorScheme.surface,
                            ),
                            child: ListTile(
                              onTap: () {
                                debugPrint('project.id: ${project.id}');
                                _onProjectSelected(project.id!);
                              },
                              selected: selected,
                              selectedTileColor: Colors.grey[300],
                              leading: CircleAvatar(
                                  radius: 15,
                                  child: Text(project.name!
                                      .substring(0, 1)
                                      .toUpperCase())),
                              title: Text(
                                project.name!.toUpperCase(),
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
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(),
                      BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, state) {
                        bool darkMode =
                            state.themeData.brightness == Brightness.dark;
                        return ListTile(
                          leading: Icon(
                            darkMode ? Icons.dark_mode : Icons.light_mode,
                          ),
                          title: const Text('Switch to Dark Mode'),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Switch(
                              splashRadius: 10,
                              value: darkMode,
                              onChanged: (value) {
                                if (value) {
                                  themeBloc.add(ThemeEvent.toggleDark);
                                } else {
                                  themeBloc.add(ThemeEvent.toggleLight);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      const ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () {
                          context.read<AuthBloc>().add(AuthLoggedOut());
                          context.goNamed(RouteNames.login);
                        },
                        
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      }),
    );
  }
}
