import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialProformaDataSource {
  Future<DataState<MaterialProformaListWithMeta>> fetchMaterialProformas({
    FilterMaterialProformaInput? filterMaterialProformaInput,
    OrderByMaterialProformaInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  });

  Future<DataState<String>> createMaterialProforma(
      {required CreateMaterialProformaParamsModel
          createMaterialProformaParamsModel});
  Future<DataState<MaterialProformaModel>> getMaterialProformaDetails(
      {required String params});
  Future<DataState<String>> editMaterialProforma(
      {required EditMaterialProformaParamsModel
          editMaterialProformaParamsModel});
  Future<DataState<String>> deleteMaterialProforma(
      {required String materialProformaId});

  Future<DataState<List<MaterialProformaEntity>>> fetchAllMaterialProformas(
      {FilterMaterialProformaInput? filterMaterialProformaInput});
}

class MaterialProformaDataSourceImpl extends MaterialProformaDataSource {
  late final GraphQLClient _client;

  // Define the mutation
  MaterialProformaDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createMaterialProformaMutation = r'''
mutation CreateProforma($createProformaInput: CreateProformaInput!) {
  createProforma(createProformaInput: $createProformaInput) {
    id
  }
}
  ''';

  static const String _deleteMaterialProformaMutation = r'''
    mutation DeleteProforma($deleteProformaId: String!) {
  deleteProforma(id: $deleteProformaId) {
    id
  }
}
''';

  static const String _uploadFiles = r'''
mutation UploadFiles($files: [Upload!]!) {
  uploadFiles(files: $files)
}
''';

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createMaterialProforma(
      {required CreateMaterialProformaParamsModel
          createMaterialProformaParamsModel}) async {
    final MutationOptions options_file =
        MutationOptions(document: gql(_uploadFiles), variables: {
      "files": createMaterialProformaParamsModel.materialProformaMaterials
          .map((e) => e.multipartFile)
          .toList()
    });

    try {
      final QueryResult file_result = await _client.mutate(options_file);
      print("*************************");

      print(file_result.data);
      print(file_result.data?['uploadFiles']);
      print(file_result.data?['uploadFiles'][0]);

      var i = 0;
      createMaterialProformaParamsModel.materialProformaMaterials.map((e) {
        e.photos = [file_result.data?['uploadFiles'][i++]];
      }).toList();
      final MutationOptions options = MutationOptions(
        document: gql(_createMaterialProformaMutation),
        variables: {
          "createProformaInput": createMaterialProformaParamsModel.toJson()
        },
      );
      // print(createMaterialProformaParamsModel.toJson());

      try {
        final QueryResult result = await _client.mutate(options);

        if (result.hasException) {
          return DataFailed(
              ServerFailure(errorMessage: result.exception.toString()));
        }

        // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
        final String id = result.data!['createProforma']['id'];

        return DataSuccess(id);
      } catch (e) {
        // In case of any other errors, return a DataFailed state
        return DataFailed(ServerFailure(errorMessage: e.toString()));
      }
    } catch (e) {
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<MaterialProformaModel>> getMaterialProformaDetails(
      {required String params}) {
    String fetchMaterialProformaDetailsQuery = r'''
query GetProformaById($getProformaByIdId: String!) {
  getProformaById(id: $getProformaByIdId) {
    id
        materialRequestItem {
      id
      quantity
      productVariant {
        id
        variant
        product {
          id
          name
        }
        unitOfMeasure
      }
    }
    items {
      createdAt
      id
      photos
      quantity
      remark
      totalPrice
      unitPrice
      updatedAt
      vendor
    }
    serialNumber
    status
    updatedAt
    preparedBy {
      id
      fullName
      email
      createdAt
      phoneNumber
      role
      updatedAt
    }
    createdAt
    approvedBy {
      id
      fullName
      email
      createdAt
      phoneNumber
      role
      updatedAt
    }
  }
}
    ''';

    return _client
        .query(QueryOptions(
      document: gql(fetchMaterialProformaDetailsQuery),
      variables: {"getProformaByIdId": params},
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

      final materialProforma =
          MaterialProformaModel.fromJson(response.data!['getProformaById']);
      print(response.data!['getProformaById']);

      return DataSuccess(materialProforma);
    });
  }

  @override
  Future<DataState<String>> editMaterialProforma(
      {required EditMaterialProformaParamsModel
          editMaterialProformaParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createMaterialProformaMutation),
      variables: {
        "createMaterialProformaInput": editMaterialProformaParamsModel.toJson()
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['updateMaterialProforma']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<String>> deleteMaterialProforma(
      {required String materialProformaId}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_deleteMaterialProformaMutation),
      variables: {"deleteProformaId": materialProformaId},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['deleteProforma']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<MaterialProformaListWithMeta>> fetchMaterialProformas({
    FilterMaterialProformaInput? filterMaterialProformaInput,
    OrderByMaterialProformaInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine = false,
  }) async {
    String fetchMaterialProformasQuery;

    fetchMaterialProformasQuery = r'''
      query GetProformas($filterProformaInput: FilterProformaInput, $mine: Boolean!, $orderBy: OrderByProformaInput, $paginationInput: PaginationInput) {
        getProformas(filterProformaInput: $filterProformaInput, mine: $mine, orderBy: $orderBy, paginationInput: $paginationInput) {
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
              photos
              quantity
              remark
              totalPrice
              unitPrice
              updatedAt
              vendor
            }
            materialRequestItem {
              createdAt
              id
              productVariantId
              proformas {
                approvedById
                createdAt
                id
                materialRequestItemId
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
                selectedProformaItem {
                  createdAt
                  id
                  photos
                  quantity
                  remark
                  totalPrice
                  unitPrice
                  updatedAt
                  vendor
                }
                selectedProformaItemId
                serialNumber
                status
                updatedAt
                approvedBy {
                  createdAt
                  email
                  fullName
                  id
                  phoneNumber
                  role
                  updatedAt
                }
                materialRequestItem {
                  createdAt
                  id
                  productVariantId
                  quantity
                  remark
                  updatedAt
                }
              }
              quantity
              remark
              updatedAt
            }
            materialRequestItemId
            preparedById
            projectId
            selectedProformaItemId
            serialNumber
            status
            updatedAt
            selectedProformaItem {
              createdAt
              id
              photos
              quantity
              remark
              totalPrice
              unitPrice
              updatedAt
              vendor
            }
          }
          meta {
            count
            limit
            page
          }
        }
      }
    ''';

    dynamic filterInput = filterMaterialProformaInput!.toJson();
    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    if (selectedProjectId != null) {
      filterInput['projectId'] = selectedProjectId;
    }

    return _client
        .query(
      QueryOptions(
        document: gql(fetchMaterialProformasQuery),
        variables: {
          'filterProformaInput': filterInput,
          'orderBy': orderBy ?? {},
          'paginationInput': paginationInput ?? {},
          "mine": mine ?? false,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    )
        .then((response) {
      if (response.hasException) {
        debugPrint(
            'fetchMaterialProformasQuery: ${response.exception.toString()}');
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      final issues = response.data!['getProformas']["items"] as List;
      final meta = response.data!['getProformas']["meta"];
      final items =
          issues.map((e) => MaterialProformaModel.fromJson(e)).toList();
      debugPrint(
          '******************Successfully converted to MaterialProformaModel: $items');
      return DataSuccess(
        MaterialProformaListWithMeta(
          items: items,
          meta: MetaModel.fromJson(meta),
        ),
      );
    });
  }

  @override
  Future<DataState<List<MaterialProformaEntity>>> fetchAllMaterialProformas({
    FilterMaterialProformaInput? filterMaterialProformaInput,
  }) async {
    String fetchAllMaterialProformasQuery;

    fetchAllMaterialProformasQuery = r'''
      query GetProformas($filterProformaInput: FilterProformaInput) {
        getProformas(filterProformaInput: $filterProformaInput) {
          items {
            id
            serialNumber
            selectedProformaItemId
            selectedProformaItem {
              createdAt
              id
              photos
              quantity
              remark
              totalPrice
              unitPrice
              updatedAt
              vendor
            }
            items {
              createdAt
              id
              photos
              quantity
              remark
              totalPrice
              unitPrice
              updatedAt
              vendor
            }
            status
          }
        }
      }
    ''';

    dynamic filterInput = filterMaterialProformaInput?.toJson() ?? {};
    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    if (selectedProjectId != null) {
      filterInput['projectId'] = selectedProjectId;
    }

    return _client
        .query(
      QueryOptions(
        document: gql(fetchAllMaterialProformasQuery),
        variables: {
          'filterProformaInput': filterInput,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    )
        .then((response) {
      if (response.hasException) {
        debugPrint(
            'fetchMaterialProformasQuery: ${response.exception.toString()}');
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      final issues = response.data!['getProformas']["items"] as List;
      final items =
          issues.map((e) => MaterialProformaModel.fromJson(e)).toList();
      debugPrint(
          '******************Successfully converted to MaterialProformaModel: $items');
      return DataSuccess(items);
    });
  }
}

class FilterMaterialProformaInput {
  final StringFilter? createdAt;
  final StringFilter? approvedBy;
  final StringFilter? preparedBy;
  final StringFilter? serialNumber;
  final List<String>? status;
  final StringFilter? projectId;

  FilterMaterialProformaInput(
      {this.createdAt,
      this.approvedBy,
      this.preparedBy,
      this.serialNumber,
      this.status,
      this.projectId});

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
      if (projectId != null) 'projectId': projectId,
    };
  }
}

class OrderByMaterialProformaInput {
  final String? createdAt;

  OrderByMaterialProformaInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
