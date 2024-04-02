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
  }) {
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
            id
            serialNumber 
            status
            approvedById 
            approvedBy {
              id
              email
              fullName
              phoneNumber
              createdAt
              role
              updatedAt
            }
            issuedToId
            items {
              description
              id
              materialIssueVoucherId
              quantity
              remark
              totalCost
              unitCost
              unitOfMeasure
            }
            preparedById
            projectDetails
            receivedById
            requisitionNumber
            createdAt
            updatedAt
          
          }
        }
      }
    ''';

    return _client
        .query(
      QueryOptions(
        document: gql(fetchMaterialIssuesQuery),
        variables: {
          'filterMaterialIssueInput': filterMaterialIssueInput?.toJson(),
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
  final StringFilter? issuedTo;
  final StringFilter? preparedBy;
  final StringFilter? receivedBy;
  final StringFilter? serialNumber;

  FilterMaterialIssueInput(
      {this.createdAt,
      this.approvedBy,
      this.issuedTo,
      this.preparedBy,
      this.receivedBy,
      this.serialNumber});

  Map<String, dynamic> toJson() {
    return {
      // 'createdAt': createdAt,
      "approvedBy": {
        "fullName": approvedBy,
      },
      "issuedTo": {
        "fullName": issuedTo,
      },
      "preparedBy": {
        "fullName": preparedBy,
      },
      "receivedBy": {
        "fullName": receivedBy,
      },
      "serialNumber": serialNumber,
    };
  }
}

class OrderByMaterialIssueInput {
  final String? createdAt;

  OrderByMaterialIssueInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
    };
  }
}
