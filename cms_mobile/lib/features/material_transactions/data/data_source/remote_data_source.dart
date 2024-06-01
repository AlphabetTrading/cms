import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class VoucherDataSource {
  Future<DataState<MaterialRequestEntityListWithMeta>> fetchMaterialRequests(
    FilterMaterialRequestInput? filterMaterialRequestInput,
    OrderByMaterialRequestInput? orderBy,
    PaginationInput? paginationInput,
  );
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
  Future<DataState<MaterialRequestEntityListWithMeta>> fetchMaterialRequests(
    FilterMaterialRequestInput? filterMaterialRequestInput,
    OrderByMaterialRequestInput? orderBy,
    PaginationInput? paginationInput,
  ) async {
    String fetchMaterialRequestsQuery;

    fetchMaterialRequestsQuery = r'''
      query GetMaterialRequests($filterMaterialRequestInput: FilterMaterialRequestInput, $orderBy: OrderByMaterialRequestInput, $paginationInput: PaginationInput) {
        getMaterialRequests(filterMaterialRequestInput: $filterMaterialRequestInput, orderBy: $orderBy, paginationInput: $paginationInput) {
          items {
            approvedBy {
              fullName
              email
              phoneNumber
              role
              updatedAt
              id
              createdAt
            }
            approvedById
            createdAt
            id
            items {
              createdAt
              id
              productVariant {
                createdAt
                description
                id
                product {
                  createdAt
                  id
                  name
                  productType
                  updatedAt
                }
                productId
                unitOfMeasure
                updatedAt
                variant
              }
              productVariantId
              quantity
              remark
              updatedAt
            }
            projectId
            requestedBy {
              createdAt
              email
              fullName
              id
              phoneNumber
              role
              updatedAt
            }
            requestedById
            serialNumber
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

    final filterInput = filterMaterialRequestInput?.toJson();
    debugPrint('filterInput: $filterInput');

    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    filterInput!["projectId"] = selectedProjectId;

    final response = await _client.query(QueryOptions(
      document: gql(fetchMaterialRequestsQuery),
      variables: {
        'filterMaterialRequestInput': filterInput,
        'orderBy': orderBy?.toJson() ?? {},
        'paginationInput': paginationInput?.toJson() ?? {},
      },
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final requests = response.data!['getMaterialRequests']["items"] as List;
    final meta = response.data!['getMaterialRequests']["meta"];
    final items =
        requests.map((e) => MaterialRequestModel.fromJson(e)).toList();

    debugPrint('fetchMaterialRequests: ${items.length}-itemsss');

    return DataSuccess(
      MaterialRequestEntityListWithMeta(
        items: items,
        meta: Meta.fromJson(meta),
      ),
    );
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

    debugPrint('selectedProjectId: $selectedProjectId');
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

      // debugPrint('fetchMaterialIssuesQuery: ${response.data}');
      final issues = response.data!['getMaterialIssues']["items"] as List;
      // debugPrint('fetchMaterialIssuesQuery: $issues');
      final meta = response.data!['getMaterialIssues']["meta"];
      final items = issues.map((e) => MaterialIssueModel.fromJson(e)).toList();
      debugPrint(
          '******************Successfully converted to MaterialIssueModel: $items');
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
      {this.createdAt,
      this.approvedBy,
      this.preparedBy,
      this.serialNumber,
      this.status});

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

class FilterMaterialRequestInput {
  final StringFilter? createdAt;
  final StringFilter? requestedBy;
  final StringFilter? approvedBy;
  final StringFilter? serialNumber;
  final List<String>? status;

  FilterMaterialRequestInput(
      {this.createdAt,
      this.requestedBy,
      this.approvedBy,
      this.serialNumber,
      this.status});

  Map<String, dynamic> toJson() {
    return {
      if (requestedBy != null)
        'requestedBy': {
          'fullName': requestedBy!.toJson(),
        },
      if (approvedBy != null)
        'approvedBy': {
          'fullName': approvedBy!.toJson(),
        },
      if (serialNumber != null) 'serialNumber': serialNumber!.toJson(),
      if (status != null) 'status': status,
    };
  }
}

class OrderByMaterialRequestInput {
  final String? createdAt;

  OrderByMaterialRequestInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
