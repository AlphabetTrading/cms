import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_return.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialReturnDataSource {
  Future<DataState<MaterialReturnListWithMeta>> fetchMaterialReturns({
    FilterMaterialReturnInput? filterMaterialReturnInput,
    OrderByMaterialReturnInput? orderBy,
    PaginationInput? paginationInput,
  });

  Future<DataState<String>> createMaterialReturn(
      {required CreateMaterialReturnParamsModel
          createMaterialReturnParamsModel});
  Future<DataState<String>> deleteMaterialReturn(
      {required String materialReturnId});

  Future<DataState<MaterialReturnModel>> getMaterialReturnDetails(
      {required String params});
}

class MaterialReturnDataSourceImpl extends MaterialReturnDataSource {
  late final GraphQLClient _client;

// Define the mutation
  MaterialReturnDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createMaterialReturn(
      {required CreateMaterialReturnParamsModel
          createMaterialReturnParamsModel}) async {
    const String _createMaterialReturnMutation = r'''
      mutation CreateMaterialReturn($createMaterialReturnInput: CreateMaterialReturnInput!) {
        createMaterialReturn(createMaterialReturnInput: $createMaterialReturnInput) {
          id
        }
      }

  ''';

    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialReturnMutation),
      variables: {
        "createMaterialReturnInput":createMaterialReturnParamsModel.toJson(),
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialReturnModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['createMaterialReturn']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<MaterialReturnListWithMeta>> fetchMaterialReturns(
      {FilterMaterialReturnInput? filterMaterialReturnInput,
      OrderByMaterialReturnInput? orderBy,
      PaginationInput? paginationInput}) async {
    const String fetchMaterialReturnsQuery = r'''
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
              issueVoucher {
                approvedBy {
                  createdAt
                  email
                  fullName
                  id
                  phoneNumber
                  role
                  updatedAt
                }
                approvedById
                createdAt
                id
                preparedBy {
                  createdAt
                  email
                  fullName
                  id
                  phoneNumber
                  role
                  updatedAt
                }
                preparedById
                projectId
                requisitionNumber
                serialNumber
                status
                updatedAt
                warehouseStore {
                  companyId
                  createdAt
                  id
                  location
                  name
                  updatedAt
                }
                warehouseStoreId
              }
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

    final filterInput = filterMaterialReturnInput?.toJson();
    debugPrint("filterInput: $filterMaterialReturnInput");
    if (filterMaterialReturnInput != null &&
        filterMaterialReturnInput.projectId != null) {
      filterInput?['projectId'] = filterMaterialReturnInput.projectId;
    } else {
      final selectedProjectId =
          await GQLClient.getFromLocalStorage('selected_project_id');

      debugPrint('selectedProjectId: $selectedProjectId');
      filterInput!["projectId"] = selectedProjectId;
    }
    debugPrint('filterInput: $filterInput');

    final QueryOptions options = QueryOptions(
      document: gql(fetchMaterialReturnsQuery),
      variables: {
        "filterMaterialReturnInput": filterInput,
        "orderByMaterialReturnInput": orderBy?.toJson(),
        "paginationInput": paginationInput?.toJson(),
        "mine": false,
      },
    );

    return _client.query(options).then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      debugPrint('fetchMaterialReturnsQuery: ${response.data}');

      final materialReturnsListWithMeta = MaterialReturnListWithMeta.fromJson(
          response.data!['getMaterialReturns']);

      return DataSuccess(materialReturnsListWithMeta);
    });
  }

  @override
  Future<DataState<String>> deleteMaterialReturn(
      {required String materialReturnId}) {
    // TODO: implement deleteMaterialReturn
    throw UnimplementedError();
  }

  @override
  Future<DataState<MaterialReturnModel>> getMaterialReturnDetails(
      {required String params}) {
    // TODO: implement getMaterialReturnDetails
    throw UnimplementedError();
  }
}

class FilterMaterialReturnInput {
  final StringFilter? createdAt;
  final StringFilter? requestedBy;
  final StringFilter? approvedBy;
  final StringFilter? serialNumber;
  final List<String>? status;
  final String? projectId;

  FilterMaterialReturnInput({
    this.createdAt,
    this.requestedBy,
    this.approvedBy,
    this.serialNumber,
    this.status,
    this.projectId,
  });

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
      if (projectId != null) 'projectId': projectId,
    };
  }
}

class OrderByMaterialReturnInput {
  final String? createdAt;

  OrderByMaterialReturnInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
