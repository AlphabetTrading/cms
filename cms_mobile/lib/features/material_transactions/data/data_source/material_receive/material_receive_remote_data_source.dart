import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
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
  Future<DataState<String>> deleteMaterialReceive(
      {required String materialReceiveId});
}

class MaterialReceiveDataSourceImpl extends MaterialReceiveDataSource {
  late final GraphQLClient _client;
// Define the mutation
  MaterialReceiveDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createMaterialReceiveMutation = r'''
mutation CreateMaterialReceive($createMaterialReceiveInput: CreateMaterialReceiveInput!) {
  createMaterialReceive(createMaterialReceiveInput: $createMaterialReceiveInput) {
    id
  }
}

  ''';

  @override
  Future<DataState<String>> createMaterialReceive(
      {required CreateMaterialReceiveParamsModel
          createMaterialReceiveParamsModel}) async {
    print(
        "createMaterialReceivingParamsModel: $createMaterialReceiveParamsModel");

    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialReceiveMutation),
      variables: {
        "createMaterialReceiveInput": createMaterialReceiveParamsModel.toJson()
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);
      print(result);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
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
    createdAt
    approvedBy {
      email
      fullName
      id
      phoneNumber
      role
      updatedAt
      createdAt
    }
    preparedBy {
      id
      fullName
      email
      createdAt
      phoneNumber
      role
      updatedAt
    }
    serialNumber
    status
    WarehouseStore {
      id
      name
      location
    }
    items {
      id
      loadingCost
      transportationCost
      remark
      receivedQuantity
      unloadingCost
      purchaseOrderItem {

             id
        totalPrice
        unitPrice
        quantity
        materialRequestItem {
          id
          productVariant {
            id
            variant
            unitOfMeasure
            product {
              id
              name
            }
          }
        }
        proforma {
          id
          serialNumber
          materialRequestItem {
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
        }
      }
    }
  }
}
    ''';

    return _client
        .query(QueryOptions(
      document: gql(fetchMaterialReceiveDetailsQuery),
      variables: {"getMaterialReceiveByIdId": params},
      fetchPolicy: FetchPolicy.noCache,
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
  Future<DataState<MaterialReceiveListWithMeta>> fetchMaterialReceivings({
    FilterMaterialReceiveInput? filterMaterialReceiveInput,
    OrderByMaterialReceiveInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  }) async {
    String fetchMaterialReceiveQuery;

    fetchMaterialReceiveQuery = r'''
     query GetMaterialReceives($filterMaterialReceiveInput: FilterMaterialReceiveInput, $orderBy: OrderByMaterialReceiveInput, $paginationInput: PaginationInput, $mine: Boolean!) {
      getMaterialReceives(filterMaterialReceiveInput: $filterMaterialReceiveInput, orderBy: $orderBy, paginationInput: $paginationInput, mine: $mine) {
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
          projectId
          serialNumber
          status
          updatedAt
          WarehouseStore {
            companyId
            createdAt
            id
            location
            name
            updatedAt
          }
          warehouseStoreId
        
          items {
            createdAt
            id
            loadingCost
            materialReceiveVoucherId
            transportationCost
            unloadingCost
            updatedAt
            remark
            receivedQuantity
            purchaseOrderItemId
            purchaseOrderItem {
              createdAt
              id
              materialRequestItemId
              proformaId
              purchaseOrderId
              quantity
              remark
              totalPrice
              unitPrice
              updatedAt
            }
          }
          MaterialTransferVoucher {
            approvedById
            createdAt
            id
            materialGroup
            materialReceiveId
            preparedById
            projectId
            receivingWarehouseStoreId
            requisitionNumber
            sendingStore
            sendingWarehouseStoreId
            sentThroughName
            serialNumber
            status
            updatedAt
            vehiclePlateNo
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
          preparedById
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

    if (filterMaterialReceiveInput != null &&
        filterMaterialReceiveInput.projectId != null) {
      filterInput?['projectId'] = filterMaterialReceiveInput.projectId;
    } else {
      final selectedProjectId =
          await GQLClient.getFromLocalStorage('selected_project_id');

      debugPrint('selectedProjectId: $selectedProjectId');
      filterInput!["projectId"] = selectedProjectId;
    }
    debugPrint('filterInput: $filterInput');
    return _client
        .query(
      QueryOptions(
        document: gql(fetchMaterialReceiveQuery),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'filterMaterialRecieveInput': filterInput,
          'orderBy': orderBy ?? {},
          'paginationInput': paginationInput ?? {},
          "mine": mine ?? false,
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

      return DataSuccess(MaterialReceiveListWithMeta.fromJson(
          response.data!["getMaterialReceives"]));
    });
  }

  static const String _deleteMaterialReceivingMutation = r'''

mutation DeleteMaterialReceive($deleteMaterialReceiveId: String!) {
  deleteMaterialReceive(id: $deleteMaterialReceiveId) {
    id
  }
}
 ''';

  @override
  Future<DataState<String>> deleteMaterialReceive(
      {required String materialReceiveId}) async {
    print('In delete Material receive data source ${materialReceiveId}');
    final MutationOptions options = MutationOptions(
      document: gql(_deleteMaterialReceivingMutation),
      variables: {"deleteMaterialReceiveId": materialReceiveId},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }
      // print('Delete material receive: ${result.data}');
      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['deleteMaterialReceive']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }
}