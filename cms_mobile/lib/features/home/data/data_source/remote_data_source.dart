import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/models/material_transactions.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialTransactionsDataSource {
  Future<DataState<List<MaterialTransactionModel>>> fetchMaterialTransactions();

}

class MaterialTransactionsDataSourceImpl
    extends MaterialTransactionsDataSource {
  late final GraphQLClient _client;

  MaterialTransactionsDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<MaterialTransactionModel>>>
      fetchMaterialTransactions() async {
    String fetchMaterialTransactionsQuery;

    fetchMaterialTransactionsQuery = r'''
      query GetAllDocumentsStatus {
        getAllDocumentsStatus {
            approvedCount
            declinedCount
            pendingCount
            type
          }
        }
    ''';

    final response = await _client.query(QueryOptions(
      document: gql(fetchMaterialTransactionsQuery),
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final requests = response.data!['getAllDocumentsStatus'] as List;

    return DataSuccess(
        requests.map((e) => MaterialTransactionModel.fromJson(e)).toList());
  }
}
