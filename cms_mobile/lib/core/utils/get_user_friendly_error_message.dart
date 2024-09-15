import 'package:graphql_flutter/graphql_flutter.dart';

String getUserFriendlyErrorMessage(OperationException exception) {
  if (exception.graphqlErrors.isNotEmpty) {
    final error = exception.graphqlErrors.first;
    return error.message;
  }

  return 'An unexpected error occurred. Please try again later.';
}
