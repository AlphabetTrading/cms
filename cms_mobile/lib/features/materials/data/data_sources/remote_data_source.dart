import 'dart:math';

import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/materials/data/models/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialsDataSource {
  Future<DataState<List<MaterialModel>>> fetchMaterials();
}

class MaterialsDataSourceImpl extends MaterialsDataSource {
  late final GraphQLClient _client;
  MaterialsDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<List<MaterialModel>>> fetchMaterials() async {
    String fetchMaterialsQuery = "";

    final response = await _client.query(QueryOptions(
      document: gql(fetchMaterialsQuery),
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }
    final requests = response.data!['requests'] as List;
    return DataSuccess(requests.map((e) => MaterialModel.fromJson(e)).toList());
  }
}
