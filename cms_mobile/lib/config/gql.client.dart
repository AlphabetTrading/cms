import 'package:cms_mobile/config/local_storage.dart';
import 'package:cms_mobile/core/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GQLClient {
  static final HttpLink httpLink = HttpLink(
    URLs.graphqlEndpoint,
  );

  static final AuthLink authLink = AuthLink(
    getToken: () async {
      final token = await getAccessTokenFromStorage();
      debugPrint('token $token');
      return 'Bearer $token';
    },
  );

  // implment refresh token using error link
  static final _errorLink = ErrorLink(
    onGraphQLError: (request, forward, response) {
      debugPrint('error link ${response.errors}');

      if (response.errors != null) {
        debugPrint('error link ${response.errors}');
        for (var err in response.errors!) {
          debugPrint('error link ${err.message}');
          if (err.message == "Unauthorized") {
            return forward(request).map((response) {
              if (response.errors != null) {
                for (var err in response.errors!) {
                  if (err.message == "Unauthorized") {
                    refreshToken();
                  }
                }
              }
              return response;
            });
          }
        }
      }
      return null;
    },
  );

  static final Link link = _errorLink.concat(authLink.concat(httpLink));

  static Future<void> refreshToken() async {
    final refreshToken = await getRefreshTokenFromStorage();
    const refreshTokenQuery = r'''
     mutation RefreshToken($refreshToken: JWT!) {
        refreshToken(refreshToken: $refreshToken) {
          accessToken
          refreshToken
        }
      }
    ''';

    final response = await client.value.mutate(MutationOptions(
      document: gql(refreshTokenQuery),
      variables: {
        "refreshToken": refreshToken,
      },
    ));
    debugPrint('refresh token ${response.data}');

    if (response.hasException) {
      throw response.exception as GraphQLError;
    }

    final authData = response.data!['refreshToken'];

    await saveToLocalStorage("jwt", authData['accessToken']);
    await saveToLocalStorage("refresh_token", authData['refreshToken']);

    return;
  }

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    ),
  );

  static getAccessTokenFromStorage() async {
    FlutterSecureStorage storage = LocalStorage().storage;
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return '';
    return jwt;
  }

  static getRefreshTokenFromStorage() async {
    FlutterSecureStorage storage = LocalStorage().storage;
    var jwt = await storage.read(key: "refresh_token");
    if (jwt == null) return '';
    return jwt;
  }

  static getUserIdFromStorage() async {
    FlutterSecureStorage storage = LocalStorage().storage;
    var jwt = await storage.read(key: "user_id");
    if (jwt == null) return '';
    return jwt;
  }

  static Future<void> clearStorage() async {
    FlutterSecureStorage storage = LocalStorage().storage;
    await storage.delete(key: "jwt");
    await storage.delete(key: "refresh_token");
    await storage.delete(key: "user_id");
  }

  static Future<void> saveToLocalStorage(String key, String value) async {
    FlutterSecureStorage storage = LocalStorage().storage;
    await storage.write(key: key, value: value);
  }

  static Future<dynamic> getFromLocalStorage(String key) async {
    FlutterSecureStorage storage = LocalStorage().storage;
    return await storage.read(key: key);
  }
}
