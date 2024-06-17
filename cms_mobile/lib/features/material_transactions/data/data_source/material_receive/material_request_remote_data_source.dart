import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_receiving.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialReceiveDataSource {
  Future<DataState<MaterialReceiveListWithMeta>> fetchMaterialReceivings({
    FilterMaterialReceiveInput? filterMaterialReceiveInput,
    OrderByMaterialReceiveInput? orderBy,
    PaginationInput? paginationInput,
  });

  Future<DataState<String>> createMaterialReceive(
      {required CreateMaterialReceiveParamsModel
          createMaterialReceiveParamsModel});

  Future<DataState<MaterialReceiveModel>> getMaterialReceiveDetails(
      {required String params});
}

class MaterialReceiveDataSourceImpl extends MaterialReceiveDataSource {
  late final GraphQLClient _client;
// Define the mutation
  MaterialReceiveDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  // Override the function in the implementation class

  @override
  Future<DataState<String>> createMaterialReceive(
      {required CreateMaterialReceiveParamsModel
          createMaterialReceiveParamsModel}) async {
    const String _createMaterialReceiveMutation = r'''
      mutation CreateMaterialReceive($createMaterialReceiveInput: CreateMaterialReceiveInput!) {
        createMaterialReceive(createMaterialReceiveInput: $createMaterialReceiveInput) {
          id
        }
      }
  ''';

    List<Map<String, dynamic>> materialReceiveMaterialsMap =
        createMaterialReceiveParamsModel.materialReceiveMaterials
            .map((materialReceiveMaterial) {
      return {
        "quantity": materialReceiveMaterial.quantity,
        "productVariantId": materialReceiveMaterial.material!.productVariant.id,
        "remark": materialReceiveMaterial.remark,
      };
    }).toList();

    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialReceiveMutation),
      variables: {
        "createMaterialReceiveInput": {
          "preparedById": createMaterialReceiveParamsModel.preparedById,
          "projectId": createMaterialReceiveParamsModel.projectId,
          "items": materialReceiveMaterialsMap
        }
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialReceiveModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['createMaterialReceive']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<MaterialReceiveModel>> getMaterialReceiveDetails(
      {required String params}) {
    String fetchMaterialReceiveDetailsQuery = r'''
query GetMaterialReceiveById($getMaterialReceiveByIdId: String!) {
  getMaterialReceiveById(id: $getMaterialReceiveByIdId) {
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
    receiveedBy {
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
      document: gql(fetchMaterialReceiveDetailsQuery),
      variables: {"getMaterialReceiveByIdId": params},
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
      print(response.data!['getMaterialReceiveById']);
      final materialReceive = MaterialReceiveModel.fromJson(
          response.data!['getMaterialReceiveById']);

      return DataSuccess(materialReceive);
    });
  }

  @override
  Future<DataState<MaterialReceiveListWithMeta>> fetchMaterialReceivings(
      {FilterMaterialReceiveInput? filterMaterialReceiveInput,
      OrderByMaterialReceiveInput? orderBy,
      PaginationInput? paginationInput}) async {
    String fetchMaterialReceiveQuery;

    fetchMaterialReceiveQuery = r'''
      query GetMaterialReceives {
        getMaterialReceives {
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
            invoiceId
            materialRequestId
            projectId
            purchaseOrderId
            purchasedBy {
              createdAt
              email
              fullName
              id
              phoneNumber
              role
              updatedAt
            }
            purchasedById
            serialNumber
            status
            supplierName
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

    final filterInput = filterMaterialReceiveInput?.toJson();
    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    debugPrint('selectedProjectId: $selectedProjectId');
    filterInput!["projectId"] = selectedProjectId;
    debugPrint('filterInput: $filterInput');
    return _client
        .query(
      QueryOptions(
        document: gql(fetchMaterialReceiveQuery),
        variables: {
          'filterMaterialRecieveInput': filterInput,
          'orderBy': orderBy ?? {},
          'paginationInput': paginationInput ?? {},
        },
      ),
    )
        .then((response) {
      if (response.hasException) {
        debugPrint(
            'fetchMaterialReceiveQuery: ${response.exception.toString()}');
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      debugPrint('fetchMaterialIssuesQuery: ${response.data}');
      final receivings = response.data!['getMaterialReceives']["items"] as List;

      debugPrint('fetchMaterialReceivingsQuery: $receivings');
      final meta = response.data!['getMaterialReceives']["meta"];

      final items =
          receivings.map((e) => MaterialReceiveModel.fromJson(e)).toList();
      debugPrint(
          '******************Successfully converted to MaterialReceiveModel: $items');
      return DataSuccess(
        MaterialReceiveListWithMeta(
          items: items,
          meta: Meta.fromJson(meta),
        ),
      );
    });
  }
}
