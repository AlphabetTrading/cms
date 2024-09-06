import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/models/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class DashboardDataSource {
  Future<DataState<DashboardModel>> getDashboardStats();
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
}
