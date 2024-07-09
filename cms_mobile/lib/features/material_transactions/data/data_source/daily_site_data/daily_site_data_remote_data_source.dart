import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class DailySiteDataDataSource {
  Future<DataState<DailySiteDataListWithMeta>> fetchDailySiteDatas({
    FilterDailySiteDataInput? filterDailySiteDataInput,
    OrderByDailySiteDataInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  });

  Future<DataState<String>> createDailySiteData(
      {required CreateDailySiteDataParamsModel createDailySiteDataParamsModel});
  Future<DataState<DailySiteDataModel>> getDailySiteDataDetails(
      {required String params});
  Future<DataState<String>> editDailySiteData(
      {required EditDailySiteDataParamsModel editDailySiteDataParamsModel});
  Future<DataState<String>> deleteDailySiteData(
      {required String dailySiteDataId});
}

class DailySiteDataDataSourceImpl extends DailySiteDataDataSource {
  late final GraphQLClient _client;

  // Define the mutation
  DailySiteDataDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createDailySiteDataMutation = r'''
    mutation CreateDailySiteData($createDailySiteDataInput: CreateDailySiteDataInput!) {
      createDailySiteData(createDailySiteDataInput: $createDailySiteDataInput) {
        id
      }
    }

  ''';

  static const String _deleteDailySiteDataMutation = r'''
    mutation DeleteDailySiteData($deleteDailySiteDataId: String!) {
      deleteDailySiteData(id: $deleteDailySiteDataId) {
        id
      }
    }
''';

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createDailySiteData(
      {required CreateDailySiteDataParamsModel
          createDailySiteDataParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createDailySiteDataMutation),
      variables: {
        "createDailySiteDataInput": createDailySiteDataParamsModel.toJson()
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['createDailySiteData']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<DailySiteDataModel>> getDailySiteDataDetails(
      {required String params}) {
    String fetchDailySiteDataDetailsQuery = r'''
      query GetDailySiteDataById($getDailySiteDataByIdId: String!) {
        getDailySiteDataById(id: $getDailySiteDataByIdId) {
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
          checkedBy {
            createdAt
            email
            fullName
            id
            phoneNumber
            role
            updatedAt
          }
          checkedById
          contractor
          createdAt
          date
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
          status
          tasks {
            createdAt
            dailySiteDataId
            description
            executedQuantity
            id
            laborDetails {
              afternoon
              createdAt
              dailySiteDataTaskId
              id
              morning
              number
              overtime
              trade
              updatedAt
            }
            materialDetails {
              createdAt
              dailySiteDataTaskId
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
              quantityUsed
              quantityWasted
              updatedAt
            }
            unit
            updatedAt
          }
          updatedAt
        }
      }
    ''';

    return _client
        .query(QueryOptions(
      document: gql(fetchDailySiteDataDetailsQuery),
      variables: {"getDailySiteDataByIdId": params},
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

      final dailySiteData =
          DailySiteDataModel.fromJson(response.data!['getDailySiteDataById']);
      print(response.data!['getDailySiteDataById']);

      return DataSuccess(dailySiteData);
    });
  }

  @override
  Future<DataState<String>> editDailySiteData(
      {required EditDailySiteDataParamsModel
          editDailySiteDataParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createDailySiteDataMutation),
      variables: {
        "createDailySiteDataInput": editDailySiteDataParamsModel.toJson()
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['updateDailySiteData']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<String>> deleteDailySiteData(
      {required String dailySiteDataId}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_deleteDailySiteDataMutation),
      variables: {"deleteDailySiteDataId": dailySiteDataId},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['deleteDailySiteData']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<DailySiteDataListWithMeta>> fetchDailySiteDatas({
    FilterDailySiteDataInput? filterDailySiteDataInput,
    OrderByDailySiteDataInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine = false,
  }) async {
    String fetchDailySiteDatasQuery;

    fetchDailySiteDatasQuery = r'''
      query GetDailySiteDatas($filterDailySiteDataInput: FilterDailySiteDataInput, $orderBy: OrderByDailySiteDataInput, $paginationInput: PaginationInput, $mine: Boolean!) {
        getDailySiteDatas(filterDailySiteDataInput: $filterDailySiteDataInput, orderBy: $orderBy, paginationInput: $paginationInput, mine: $mine) {
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
            checkedBy {
              createdAt
              email
              fullName
              id
              phoneNumber
              role
              updatedAt
            }
            checkedById
            contractor
            createdAt
            date
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
            status
            tasks {
              createdAt
              dailySiteDataId
              description
              executedQuantity
              id
              laborDetails {
                afternoon
                createdAt
                dailySiteDataTaskId
                id
                morning
                number
                overtime
                trade
                updatedAt
              }
              materialDetails {
                createdAt
                dailySiteDataTaskId
                id
                productVariantId
                quantityUsed
                quantityWasted
                updatedAt
              }
              unit
              updatedAt
            }
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

    dynamic filterInput = filterDailySiteDataInput!.toJson();
    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    if (selectedProjectId != null) {
      filterInput['projectId'] = selectedProjectId;
    }

    return _client
        .query(
      QueryOptions(
        document: gql(fetchDailySiteDatasQuery),
        variables: {
          'filterDailySiteDataInput': filterInput,
          'orderBy': orderBy ?? {},
          'paginationInput': paginationInput ?? {},
          "mine": mine ?? false,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    )
        .then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      // debugPrint('fetchDailySiteDatasQuery: ${response.data}');
      final issues = response.data!['getDailySiteDatas']["items"] as List;
      // debugPrint('fetchDailySiteDatasQuery: $issues');
      final meta = response.data!['getDailySiteDatas']["meta"];
      final items = issues.map((e) => DailySiteDataModel.fromJson(e)).toList();
      return DataSuccess(
        DailySiteDataListWithMeta(
          items: items,
          meta: MetaModel.fromJson(meta),
        ),
      );
    });
  }
}

class FilterDailySiteDataInput {
  final StringFilter? createdAt;
  final StringFilter? approvedBy;
  final StringFilter? preparedBy;
  final StringFilter? serialNumber;
  final List<String>? status;
  final StringFilter? projectId;

  FilterDailySiteDataInput(
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

class OrderByDailySiteDataInput {
  final String? createdAt;

  OrderByDailySiteDataInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
