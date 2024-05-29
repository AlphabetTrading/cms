import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialRequestDataSource {
  Future<DataState<String>> createMaterialRequest(
      {required CreateMaterialRequestParamsModel
          createMaterialRequestParamsModel});

  Future<DataState<List<MaterialRequestModel>>> fetchMaterialRequests();
}

class MaterialRequestDataSourceImpl extends MaterialRequestDataSource {
  late final GraphQLClient _client;
// Define the mutation
  MaterialRequestDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  // Override the function in the implementation class

  @override
  Future<DataState<List<MaterialRequestModel>>> fetchMaterialRequests() async {
    String fetchMaterialRequestsQuery;


    fetchMaterialRequestsQuery = r'''
      query GetMaterialRequests($orderBy: OrderByMaterialRequestInput, $filterMaterialRequestInput: FilterMaterialRequestInput, $paginationInput: PaginationInput) {
        getMaterialRequests(orderBy: $orderBy, filterMaterialRequestInput: $filterMaterialRequestInput, paginationInput: $paginationInput) {
          meta {
            count
            limit
            page
          }
          items {
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
            items {
              createdAt
              id
              productVariant {
                createdAt
                description
                id
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

    final requests = response.data!['getMaterialRequests'] as List;

    return DataSuccess(
        requests.map((e) => MaterialRequestModel.fromJson(e)).toList());
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
        "productVariantId": materialRequestMaterial.material!.itemVariant.id,
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
}
