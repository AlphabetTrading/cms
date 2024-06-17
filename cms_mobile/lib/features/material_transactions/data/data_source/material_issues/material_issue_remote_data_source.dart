import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialIssueDataSource {
  Future<DataState<MaterialIssueListWithMeta>> fetchMaterialIssues({
    FilterMaterialIssueInput? filterMaterialIssueInput,
    OrderByMaterialIssueInput? orderBy,
    PaginationInput? paginationInput,
  });

  Future<DataState<String>> createMaterialIssue(
      {required CreateMaterialIssueParamsModel createMaterialIssueParamsModel});
  Future<DataState<MaterialIssueModel>> getMaterialIssueDetails(
      {required String params});
  Future<DataState<String>> editMaterialIssue(
      {required EditMaterialIssueParamsModel editMaterialIssueParamsModel});
  Future<DataState<String>> deleteMaterialIssue({required String materialId});
}

class MaterialIssueDataSourceImpl extends MaterialIssueDataSource {
  late final GraphQLClient _client;

  // Define the mutation
  MaterialIssueDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createMaterialIssueMutation = r'''
    mutation CreateMaterialIssue($createMaterialIssueInput: CreateMaterialIssueInput!) {
      createMaterialIssue(createMaterialIssueInput: $createMaterialIssueInput) {
        id
      }
    }

  ''';

  static const String _deleteMaterialIssueMutation = r'''
    mutation DeleteMaterialIssue($deleteMaterialIssueId: String!) {
      deleteMaterialIssue(id: $deleteMaterialIssueId) {
        id
      }
    }
''';

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createMaterialIssue(
      {required CreateMaterialIssueParamsModel
          createMaterialIssueParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialIssueMutation),
      variables: {
        "createMaterialIssueInput": createMaterialIssueParamsModel.toJson()
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['createMaterialIssue']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<MaterialIssueModel>> getMaterialIssueDetails(
      {required String params}) {
    String fetchMaterialIssueDetailsQuery = r'''
      query GetMaterialIssueById($getMaterialIssueByIdId: String!) {
        getMaterialIssueById(id: $getMaterialIssueByIdId) {
          items {
            id
            createdAt
            productVariant {
              id
              description
              unitOfMeasure
              variant
              productId
              product {
                id
                name
                productType
                createdAt
                updatedAt
              }
              createdAt
              updatedAt
            }
            quantity
            remark
            totalCost
            unitCost
            subStructureDescription
            superStructureDescription
            updatedAt
            useType
            materialIssueVoucherId
          }
          requisitionNumber
          serialNumber
          status
          id
          
          approvedById
          createdAt
          approvedBy {

                    createdAt
                    email
                    fullName
                    id
                    phoneNumber
                    role
                    updatedAt
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
            id
            location
            name
          }
        }
      }
    ''';

    return _client
        .query(QueryOptions(
      document: gql(fetchMaterialIssueDetailsQuery),
      variables: {"getMaterialIssueByIdId": params},
    ))
        .then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      final materialIssue =
          MaterialIssueModel.fromJson(response.data!['getMaterialIssueById']);
      print(response.data!['getMaterialIssueById']);

      return DataSuccess(materialIssue);
    });
  }

  @override
  Future<DataState<String>> editMaterialIssue(
      {required EditMaterialIssueParamsModel
          editMaterialIssueParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialIssueMutation),
      variables: {
        "createMaterialIssueInput": editMaterialIssueParamsModel.toJson()
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['updateMaterialIssue']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<String>> deleteMaterialIssue(
      {required String materialId}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_deleteMaterialIssueMutation),
      variables: {"deleteMaterialIssueId": materialId},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['deleteMaterialIssue']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<MaterialIssueListWithMeta>> fetchMaterialIssues({
    FilterMaterialIssueInput? filterMaterialIssueInput,
    OrderByMaterialIssueInput? orderBy,
    PaginationInput? paginationInput,
  }) async {
    String fetchMaterialIssuesQuery;

    fetchMaterialIssuesQuery = r'''
     query GetMaterialReturns($filterMaterialReturnInput: FilterMaterialReturnInput, $mine: Boolean!, $orderBy: OrderByMaterialReturnInput, $paginationInput: PaginationInput) {
        getMaterialReturns(filterMaterialReturnInput: $filterMaterialReturnInput, mine: $mine, orderBy: $orderBy, paginationInput: $paginationInput) {
          items {
            createdAt
            id
            items {
              createdAt
              id
              issueVoucherId
              materialReturnVoucherId
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
              remark
              totalCost
              unitCost
              updatedAt
              quantity
            }
            projectId
            receivedBy {
              createdAt
              email
              fullName
              id
              phoneNumber
              role
              updatedAt
            }
            receivedById
            returnedBy {
              createdAt
              email
              fullName
              id
              phoneNumber
              role
              updatedAt
            }
            returnedById
            serialNumber
            status
            updatedAt
            receivingWarehouseStore {
              createdAt
              id
              location
              name
              updatedAt
            }
            receivingWarehouseStoreId
          }
          meta {
            count
            limit
            page
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
          "mine": false,
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
