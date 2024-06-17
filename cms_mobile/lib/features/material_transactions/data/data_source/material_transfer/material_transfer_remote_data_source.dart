import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialTransferDataSource {
  Future<DataState<String>> createMaterialTransfer(
      {required CreateMaterialTransferParamsEntity
          createMaterialTransferParamsModel});

  Future<DataState<List<MaterialTransferModel>>> fetchMaterialTransfers();
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
  Future<DataState<List<MaterialTransferModel>>>
      fetchMaterialTransfers() async {
    String fetchMaterialTransfersQuery;

    fetchMaterialTransfersQuery = r'''
      query GetMaterialTransfers($orderBy: OrderByMaterialTransferInput, $filterMaterialTransferInput: FilterMaterialTransferInput, $paginationInput: PaginationInput) {
        getMaterialTransfers(orderBy: $orderBy, filterMaterialTransferInput: $filterMaterialTransferInput, paginationInput: $paginationInput) {
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
            receiveedBy {
              createdAt
              email
              fullName
              id
              phoneNumber
              role
              updatedAt
            }
            receiveedById
            serialNumber
            status
            updatedAt
          }
        }
      }
    ''';

    final response = await _client.query(QueryOptions(
      document: gql(fetchMaterialTransfersQuery),
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final receives = response.data!['getMaterialTransfers'] as List;

    return DataSuccess(
        receives.map((e) => MaterialTransferModel.fromJson(e)).toList());
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
      {required CreateMaterialTransferParamsEntity<
              MaterialTransferEntity>
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
