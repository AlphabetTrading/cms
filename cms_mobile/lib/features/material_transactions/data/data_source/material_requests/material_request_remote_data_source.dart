import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialRequestDataSource {
  Future<DataState<MaterialRequestEntityListWithMeta>> fetchMaterialRequests(
    FilterMaterialRequestInput? filterMaterialRequestInput,
    OrderByMaterialRequestInput? orderBy,
    PaginationInput? paginationInput,
  );

  Future<DataState<String>> createMaterialRequest(
      {required CreateMaterialRequestParamsModel
          createMaterialRequestParamsModel});

  Future<DataState<MaterialRequestModel>> getMaterialRequestDetails(
      {required String params});
}

class MaterialRequestDataSourceImpl extends MaterialRequestDataSource {
  late final GraphQLClient _client;
// Define the mutation
  MaterialRequestDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  // Override the function in the implementation class
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
  Future<DataState<String>> createMaterialRequest(
      {required CreateMaterialRequestParamsModel
          createMaterialRequestParamsModel}) async {
    const String _createMaterialRequestMutation = r'''
      mutation CreateMaterialRequest($createMaterialRequestInput: CreateMaterialRequestInput!) {
        createMaterialRequest(createMaterialRequestInput: $createMaterialRequestInput) {
          id
        }
      }
  ''';

    List<Map<String, dynamic>> materialRequestMaterialsMap =
        createMaterialRequestParamsModel.materialRequestMaterials
            .map((materialRequestMaterial) {
      return {
        "quantity": materialRequestMaterial.requestedQuantity,
        "productVariantId": materialRequestMaterial.material!.productVariant.id,
        "remark": materialRequestMaterial.remark,
      };
    }).toList();

    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialRequestMutation),
      variables: {
        "createMaterialRequestInput": {
          "requestedById": createMaterialRequestParamsModel.requestedById,
          "projectId": createMaterialRequestParamsModel.projectId,
          "items": materialRequestMaterialsMap
        }
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['createMaterialRequest']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<MaterialRequestModel>> getMaterialRequestDetails(
      {required String params}) {
    String fetchMaterialRequestDetailsQuery = r'''
query GetMaterialRequestById($getMaterialRequestByIdId: String!) {
  getMaterialRequestById(id: $getMaterialRequestByIdId) {
    id
    items {
      id
      quantity
      remark
      productVariant {
        id
        unitOfMeasure
        variant
        product {
          id
          name
        }
      }
    }
    serialNumber
    status
    requestedBy {
      id
      fullName
      email
      phoneNumber
      role
    }
    createdAt
    approvedBy {
      phoneNumber
      id
      fullName
      email
      role
    }
  }
}
    ''';

    return _client
        .query(QueryOptions(
      document: gql(fetchMaterialRequestDetailsQuery),
      variables: {"getMaterialRequestByIdId": params},
    ))
        .then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      print("****************************");
      print(response.data!['getMaterialRequestById']);
      final materialRequest = MaterialRequestModel.fromJson(
          response.data!['getMaterialRequestById']);

      return DataSuccess(materialRequest);
    });
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
