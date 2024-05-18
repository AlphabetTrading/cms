import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/projects/data/models/project.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class ProjectDataSource {
  // Future<DataState<List<ProjectModel>>> fetchProjects();
  Future<DataState<ProjectListWithMeta>> fetchProjects({
    FilterProjectInput? filterProjectInput,
    OrderByProjectInput? orderBy,
    PaginationInput? paginationInput,
  });

  Future<DataState<String>> selectProject(String id);
  Future<DataState<String?>> getSelectedProject();
}

class ProjectDataSourceImpl extends ProjectDataSource {
  late final GraphQLClient _client;

  ProjectDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<ProjectListWithMeta>> fetchProjects({
    FilterProjectInput? filterProjectInput,
    OrderByProjectInput? orderBy,
    PaginationInput? paginationInput,
  }) {
    String fetchProjectsQuery;

    fetchProjectsQuery = r'''
      query ProjectQuery($filterProjectInput: FilterProjectInput, $paginationInput: PaginationInput, $orderBy: OrderByProjectInput) {
        getProjects(filterProjectInput: $filterProjectInput, paginationInput: $paginationInput, orderBy: $orderBy) {
          items {
            Client {
              id
            }
            budget
            clientId
            createdAt
            endDate
            id
            Milestones {
              id
              name
            }
            name
            ProjectManager {
              id
            }
            projectManagerId
            ProjectUsers {
              id
            }
            startDate
            status
            updatedAt
          }
          meta {
            count
            limit
            page
          }
        }
      }

    ''';
    debugPrint('fetchProjectsQuery: ');

    return _client
        .query(
      QueryOptions(
        document: gql(fetchProjectsQuery),
        variables: {
          'filterProjectInput': {},
          'orderBy': orderBy ?? {},
          'paginationInput': paginationInput ?? {},
        },
      ),
    )
        .then((response) {
      if (response.hasException) {
        debugPrint('fetchProjectsQuery: ${response.exception.toString()}');
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      debugPrint('fetchProjectsQuery: ${response.data}');
      final projects = response.data!['getProjects']["items"] as List;
      final meta = response.data!['getProjects']["meta"];
      final items = projects.map((e) => ProjectModel.fromJson(e)).toList();
      debugPrint('fetchProjectsQuery: ${items.length}');
      return DataSuccess(
        ProjectListWithMeta(
          items: items,
          meta: Meta.fromJson(meta),
        ),
      );
    });
  }

  @override
  Future<DataState<String>> selectProject(String id) async {
    await GQLClient.saveToLocalStorage(
      'selected_project_id',
      id,
    );

    return DataSuccess(id);
  }

  @override
  Future<DataState<String?>> getSelectedProject() async {
    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    // check if selectedProjectId is null, if it it, fetch the first project and set it as selected
    if (selectedProjectId == null) {
      final projects = await fetchProjects(
        filterProjectInput: FilterProjectInput(),
        orderBy: OrderByProjectInput(createdAt: 'asc'),
        paginationInput: PaginationInput(skip: 0, take: 5),
      );

      if (projects is DataSuccess) {
        if (projects.data!.items.isNotEmpty) {
          debugPrint('getSelectedProject: ${projects.data!.items.first.id}');
          await selectProject(projects.data!.items.first.id!);
          return DataSuccess(projects.data!.items.first.id);
        }
      }
    }
    debugPrint('getSelectedProject: $selectedProjectId');
    return DataSuccess(selectedProjectId);
  }
}

class FilterProjectInput {
  final StringFilter? createdAt;

  FilterProjectInput({
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'createdAt': createdAt,
      // "approvedBy": {
      //   "fullName": approvedBy,
      // },
      // "issuedTo": {
      //   "fullName": issuedTo,
      // },
      // "preparedBy": {
      //   "fullName": preparedBy,
      // },
      // "receivedBy": {
      //   "fullName": receivedBy,
      // },
      // "serialNumber": serialNumber,
    };
  }
}

class OrderByProjectInput {
  final String? createdAt;

  OrderByProjectInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
    };
  }
}
