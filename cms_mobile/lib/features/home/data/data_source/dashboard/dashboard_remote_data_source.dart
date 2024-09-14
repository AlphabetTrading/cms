import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/models/dashboard.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class DashboardDataSource {
  Future<DataState<DashboardModel>> getDashboardStats();
  Future<DataState<DetailedExpenseStatsModel>> getDetailedExpenseStats(
      {required FilterExpenseInput filterExpenseInput});
  Future<DataState<DetailedStockStatsModel>> getDetailedStockStats(
      {required FilterStockInput filterStockInput});
}

class DashboardDataSourceImpl extends DashboardDataSource {
  late final GraphQLClient _client;

  // Constructor to initialize the GraphQLClient
  DashboardDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<DashboardModel>> getDashboardStats() async {
    String getDashboardStatsQuery;

    getDashboardStatsQuery = r'''
      query GetDashboardStats($getDashboardStatsId: String!) {
        getDashboardStats(id: $getDashboardStatsId) {
          duration {
            days
            hours
            minutes
            seconds
          }
          expenditure {
            totalExpenditure
            totalItemCost
            totalLaborCost
            totalTransportationCost
          }
          progress
        }
      }
    ''';

    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    debugPrint('selectedProjectId $selectedProjectId');

    final response = await _client.query(QueryOptions(
      document: gql(getDashboardStatsQuery),
      variables: {'getDashboardStatsId': selectedProjectId},
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final result = response.data!['getDashboardStats'] as Map<String, dynamic>;

    return DataSuccess(DashboardModel.fromJson(result));
  }

  @override
  Future<DataState<DetailedExpenseStatsModel>> getDetailedExpenseStats(
      {required FilterExpenseInput filterExpenseInput}) async {
    String getDetailedExpenseStatsQuery;

    getDetailedExpenseStatsQuery = r'''
      query GetDetailedExpenseStats($filterExpenseInput: FilterExpenseInput!) {
        getDetailedExpenseStats(filterExpenseInput: $filterExpenseInput) {
          totalItemCost
          totalItemCount
          spendingHistory {
            date
            itemCost
            productVariant {
              id
              variant
              unitOfMeasure
              description
              productId
              product {
                id
                name
                productType
                createdAt
                updatedAt
              }
              updatedAt
              createdAt
            }
            productVariantId
            quantity
          }
        }
      }
    ''';

    dynamic filterInput = filterExpenseInput.toJson();
    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    if (selectedProjectId != null) {
      filterInput['projectId'] = selectedProjectId;
    }

    debugPrint('filter input $filterInput');

    return _client
        .query(
      QueryOptions(
        document: gql(getDetailedExpenseStatsQuery),
        variables: {
          'filterExpenseInput': filterInput,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    )
        .then((response) {
      debugPrint('response $response');
      if (response.hasException) {
        debugPrint('filterExpenseInput: ${response.exception.toString()}');
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      // final stats = response.data!['getDetailedExpenseStats'];
      // debugPrint(stats);
      // debugPrint("STATS");
      // final detailedExpenseStats = DetailedExpenseStatsModel.fromJson(stats);

      // return DataSuccess(detailedExpenseStats);

      final result =
          response.data!['getDetailedExpenseStats'] as Map<String, dynamic>;

      return DataSuccess(DetailedExpenseStatsModel.fromJson(result));
    });
  }

  @override
  Future<DataState<DetailedStockStatsModel>> getDetailedStockStats(
      {required FilterStockInput filterStockInput}) async {
    String getDetailedStockStatsQuery;

    getDetailedStockStatsQuery = r'''
      query GetDetailedStockStats($filterStockInput: FilterStockInput!) {
        getDetailedStockStats(filterStockInput: $filterStockInput) {
          totalItemBought
          totalItemLost
          totalItemUsed
          totalItemWasted
        }
      }
    ''';

    dynamic filterInput = filterStockInput.toJson();
    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');

    if (selectedProjectId != null) {
      filterInput['projectId'] = selectedProjectId;
    }

    return _client
        .query(
      QueryOptions(
        document: gql(getDetailedStockStatsQuery),
        variables: {
          'filterStockInput': filterInput,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    )
        .then((response) {
      if (response.hasException) {
        debugPrint('filterStockInput: ${response.exception.toString()}');
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      final result =
          response.data!['getDetailedStockStats'] as Map<String, dynamic>;

      return DataSuccess(DetailedStockStatsModel.fromJson(result));

    });
  }
}

class FilterExpenseInput {
  final String? productId;
  final ProductModel? productType;
  final String? productVariantId;
  final String? projectId;
  final String? filterPeriod;

  FilterExpenseInput({
    this.productId,
    this.productType,
    this.productVariantId,
    this.projectId,
    this.filterPeriod,
  });

  Map<String, dynamic> toJson() {
    return {
      if (productType != null)
        'productType': {
          'name': productType!.toJson(),
        },
      if (filterPeriod != null) 'filterPeriod': filterPeriod,
      if (productId != null) 'productId': productId,
      if (productVariantId != null) 'productVariantId': productVariantId,
      if (projectId != null) 'projectId': projectId,
    };
  }

  FilterExpenseInput copyWith({
    String? productId,
    ProductModel? productType,
    String? productVariantId,
    String? projectId,
    String? filterPeriod,
  }) {
    return FilterExpenseInput(
      productId: productId ?? this.productId,
      productType: productType ?? this.productType,
      productVariantId: productVariantId ?? this.productVariantId,
      filterPeriod: filterPeriod ?? this.filterPeriod,
      projectId: projectId ?? this.projectId,
    );
  }
}

class FilterStockInput {
  final String? productVariantId;
  final String? projectId;
  final String? filterPeriod;

  FilterStockInput({
    this.productVariantId,
    this.projectId,
    this.filterPeriod,
  });

  Map<String, dynamic> toJson() {
    return {
      if (filterPeriod != null) 'filterPeriod': filterPeriod,
      if (productVariantId != null) 'productVariantId': productVariantId,
      if (projectId != null) 'projectId': projectId,
    };
  }

  FilterStockInput copyWith({
    String? productVariantId,
    String? projectId,
    String? filterPeriod,
  }) {
    return FilterStockInput(
      productVariantId: productVariantId ?? this.productVariantId,
      filterPeriod: filterPeriod ?? this.filterPeriod,
      projectId: projectId ?? this.projectId,
    );
  }
}
