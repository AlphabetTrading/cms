import 'package:graphql_flutter/graphql_flutter.dart';

abstract class DataState<T> {
  final T? data;
  final GraphQLError? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(GraphQLError error) : super(error: error);
}
