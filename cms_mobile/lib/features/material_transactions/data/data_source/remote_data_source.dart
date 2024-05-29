import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class VoucherDataSource {
  Future<DataState<List<MaterialRequestModel>>> fetchMaterialRequests();
  Future<DataState<MaterialIssueListWithMeta>> fetchMaterialIssues({
    FilterMaterialIssueInput? filterMaterialIssueInput,
    OrderByMaterialIssueInput? orderBy,
    PaginationInput? paginationInput,
  });
}

class VoucherDataSourceImpl extends VoucherDataSource {
  late final GraphQLClient _client;

  VoucherDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<MaterialRequestModel>>> fetchMaterialRequests() async {
    String fetchMaterialRequestsQuery;

    fetchMaterialRequestsQuery = r'''
     query GetMaterialRequests {
        materialRequests_materialRequests {
          id
        }
      }
    ''';

    final response = await _client.query(QueryOptions(
      document: gql(fetchMaterialRequestsQuery),
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final requests = response.data!['requests'] as List;

    return DataSuccess(
        requests.map((e) => MaterialRequestModel.fromJson(e)).toList());
  }

  @override
  Future<DataState<MaterialIssueListWithMeta>> fetchMaterialIssues({
    FilterMaterialIssueInput? filterMaterialIssueInput,
    OrderByMaterialIssueInput? orderBy,
    PaginationInput? paginationInput,
  }) async {
    String fetchMaterialIssuesQuery;

    fetchMaterialIssuesQuery = r'''
      query GetMaterialIssues($filterMaterialIssueInput: FilterMaterialIssueInput, $orderBy: OrderByMaterialIssueInput, $paginationInput: PaginationInput) {
        getMaterialIssues(filterMaterialIssueInput: $filterMaterialIssueInput, orderBy: $orderBy, paginationInput: $paginationInput) {
          meta {
            count
            limit
            page
          }
          items {
            approvedById
            createdAt
            id
            preparedById
            projectId
            requisitionNumber
            serialNumber
            status
            updatedAt
            warehouseStoreId
            items {
              createdAt
              id
              materialIssueVoucherId
              productVariant {
                id
              }
              productVariantId
              quantity
              remark
              subStructureDescription
              superStructureDescription
              totalCost
              unitCost
              updatedAt
              useType
            }
            preparedBy {
              createdAt
              email
              fullName
              id
              phoneNumber
              role
              updatedAt
            }
            warehouseStore {
              createdAt
              id
              location
              name
              updatedAt
            }
          }
        }
      }
    ''';

    final filterInput = filterMaterialIssueInput?.toJson();
    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    filterInput!["projectId"] = selectedProjectId;
    debugPrint('filterInput: $filterInput');
    return _client
        .query(
      QueryOptions(
        document: gql(fetchMaterialIssuesQuery),
        variables: {
          'filterMaterialIssueInput': filterInput,
          'orderBy': orderBy ?? {},
          'paginationInput': paginationInput ?? {},
        },
      ),
    )
        .then((response) {
      if (response.hasException) {
        debugPrint(
            'fetchMaterialIssuesQuery: ${response.exception.toString()}');
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      debugPrint('fetchMaterialIssuesQuery: ${response.data}');
      final issues = response.data!['getMaterialIssues']["items"] as List;
      debugPrint('fetchMaterialIssuesQuery: $issues');
      final meta = response.data!['getMaterialIssues']["meta"];
      final items = issues.map((e) => MaterialIssueModel.fromJson(e)).toList();
      debugPrint('******************Successfully converted to MaterialIssueModel: $items');
      return DataSuccess(
        MaterialIssueListWithMeta(
          items: items,
          meta: Meta.fromJson(meta),
        ),
      );
    });
  }
}

class FilterMaterialIssueInput {
  final StringFilter? createdAt;
  final StringFilter? approvedBy;
  final StringFilter? preparedBy;
  final StringFilter? serialNumber;
  final List<String>? status;

  FilterMaterialIssueInput(
      {this.createdAt, this.approvedBy, this.preparedBy, this.serialNumber, this.status});

  Map<String, dynamic> toJson() {
    // include the property if it is only not null
    return {
      if (approvedBy != null)
        'approvedBy': {
          'fullName': approvedBy!.toJson(),
        },
      if (preparedBy != null)
        'preparedBy': {
          'fullName': preparedBy!.toJson(),
        },
      if (serialNumber != null) 'serialNumber': serialNumber!.toJson(),
      if (status != null) 'status': status,
    };
  }
}

class OrderByMaterialIssueInput {
  final String? createdAt;

  OrderByMaterialIssueInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
