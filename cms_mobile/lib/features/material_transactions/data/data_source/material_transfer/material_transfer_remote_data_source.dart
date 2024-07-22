import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialTransferDataSource {
  Future<DataState<String>> createMaterialTransfer(
      {required CreateMaterialTransferParamsEntity
          createMaterialTransferParamsModel});

  Future<DataState<MaterialTransferEntityListWithMeta>> fetchMaterialTransfers({
    FilterMaterialTransferInput? filterMaterialTransferInput,
    OrderByMaterialTransferInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  });

  Future<DataState<MaterialTransferModel>> getMaterialTransferDetails(
      {required String params});

  Future<DataState<String>> editMaterialTransfer(
      {required EditMaterialTransferParamsEntity
          editMaterialTransferParamsModel});

  Future<DataState<String>> deleteMaterialTransfer(
      {required String materialId});
}

class MaterialTransferDataSourceImpl extends MaterialTransferDataSource {
  late final GraphQLClient _client;

  MaterialTransferDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }
  @override
  Future<DataState<MaterialTransferEntityListWithMeta>> fetchMaterialTransfers(
      {FilterMaterialTransferInput? filterMaterialTransferInput,
      OrderByMaterialTransferInput? orderBy,
      PaginationInput? paginationInput, 
      bool? mine,
      }) async {
    String fetchMaterialTransfersQuery;

    fetchMaterialTransfersQuery = r'''
      query GetMaterialTransfers($filterMaterialTransferInput: FilterMaterialTransferInput, $mine: Boolean!, $orderBy: OrderByMaterialTransferInput, $paginationInput: PaginationInput) {
        getMaterialTransfers(filterMaterialTransferInput: $filterMaterialTransferInput, mine: $mine, orderBy: $orderBy, paginationInput: $paginationInput) {
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
              materialTransferVoucherId
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
              quantityRequested
              quantityTransferred
              remark
              totalCost
              unitCost
              updatedAt
            }
            materialGroup
            materialReceive {
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
              purchaseOrder {
                approvedById
                createdAt
                grandTotal
                id
                preparedById
                projectId
                serialNumber
                status
                subTotal
                updatedAt
                vat
              }
              purchaseOrderId
              purchasedById
              serialNumber
              status
              updatedAt
            }
            materialReceiveId
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
            receivingWarehouseStore {
              createdAt
              id
              location
              name
              updatedAt
            }
            receivingWarehouseStoreId
            requisitionNumber
            sendingStore
            sendingWarehouseStore {
              createdAt
              id
              location
              name
              updatedAt
            }
            sendingWarehouseStoreId
            sentThroughName
            serialNumber
            status
            updatedAt
            vehiclePlateNo
          }
          meta {
            count
            limit
            page
          }
        }
      }
    ''';

    final response = await _client.query(QueryOptions(
      document: gql(fetchMaterialTransfersQuery),
      variables: {
        "filterMaterialTransferInput": filterMaterialTransferInput?.toJson(),
        "orderBy": orderBy?.toJson(),
        "paginationInput": paginationInput?.toJson(),
        "mine": mine ?? false,
      },
      fetchPolicy: FetchPolicy.noCache,
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final receives = response.data!['getMaterialTransfers'];

    return DataSuccess(
      MaterialTransferEntityListWithMeta.fromJson(receives),
    );
  }

  @override
  Future<DataState<MaterialTransferModel>> getMaterialTransferDetails(
      {required String params}) {
    String fetchMaterialTransferDetailsQuery = r'''
query GetMaterialTransferById($getMaterialTransferByIdId: String!) {
  getMaterialTransferById(id: $getMaterialTransferByIdId) {
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
      document: gql(fetchMaterialTransferDetailsQuery),
      variables: {"getMaterialTransferByIdId": params},
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
      print(response.data!['getMaterialTransferById']);
      final materialTransfer = MaterialTransferModel.fromJson(
          response.data!['getMaterialTransferById']);

      return DataSuccess(materialTransfer);
    });
  }

  @override
  Future<DataState<String>> createMaterialTransfer(
      {required CreateMaterialTransferParamsEntity<MaterialTransferEntity>
          createMaterialTransferParamsModel}) {
    // TODO: implement createMaterialTransfer
    throw UnimplementedError();
  }

  @override
  Future<DataState<String>> deleteMaterialTransfer(
      {required String materialId}) {
    // TODO: implement deleteMaterialTransfer
    throw UnimplementedError();
  }

  @override
  Future<DataState<String>> editMaterialTransfer(
      {required editMaterialTransferParamsModel}) {
    // TODO: implement editMaterialTransfer
    throw UnimplementedError();
  }
}

class FilterMaterialTransferInput {
  final StringFilter? createdAt;
  final StringFilter? requestedBy;
  final StringFilter? approvedBy;
  final StringFilter? serialNumber;
  final List<String>? status;

  FilterMaterialTransferInput(
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

class OrderByMaterialTransferInput {
  final String? createdAt;

  OrderByMaterialTransferInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
