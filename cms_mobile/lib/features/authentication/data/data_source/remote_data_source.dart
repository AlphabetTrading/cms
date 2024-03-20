import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/authentication/data/models/sign_in_model.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class AuthenticationRemoteDataSource {
  Future<DataState<LoginModel>> login(LoginParams loginParams);
  Future<DataState<LoginModel>> register(String phone, String password);
  Future<DataState<UserModel>> getUser();
  Future<DataState<LoginModel>> logout();
  Future<bool> isSignedIn();
}

class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  late final GraphQLClient _client;

  AuthenticationRemoteDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<LoginModel>> login(
    LoginParams loginParams,
  ) async {
    debugPrint(
        'LoginParams: ${loginParams.phoneNumber}, ${loginParams.password}');

    String loginQuery;

    loginQuery = r'''
     mutation Login($data: LoginInput!) {
        login(data: $data) {
          accessToken
          refreshToken
          userId
        }
      }
    ''';

    final response = await _client.mutate(MutationOptions(
      document: gql(loginQuery),
      variables: {
        "data": {
          "phone_number": "+251912345670",
          "password": "Password@1"
          // "phone_number": loginParams.phoneNumber,
          // "password": loginParams.password,
        }
      },
    ));

    if (response.hasException) {
      debugPrint('LoginError: ${response.exception.toString()}');

      if (response.exception.toString().contains('Unauthorized')) {
        return DataFailed(
          UnauthorizedRequestFailure(
            errorMessage:
                response.exception!.graphqlErrors[0].message.toString(),
          ),
        );
      }

      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final authData = response.data!['login'];

    await saveToLocalStorage(authData);

    return DataSuccess(LoginModel.fromJson(authData));
  }

  @override
  Future<DataState<LoginModel>> register(String phone, String password) async {
    String registerQuery;

    registerQuery = r'''
      mutation Register($phone: String!, $password: String!) {
        register(phone: $phone, password: $password) {
          id
          phone
          token
        }
      }
    ''';

    final response = await _client.mutate(MutationOptions(
      document: gql(registerQuery),
      variables: {
        'phone': phone,
        'password': password,
      },
    ));

    if (response.hasException) {
      if (response.exception.toString().contains('Unauthorized')) {
        debugPrint('RegisterError: ${response.exception.toString()}');
        return DataFailed(
          UnauthorizedRequestFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final authData = response.data!['register'];

    return DataSuccess(LoginModel.fromJson(authData));
  }

  @override
  Future<DataState<UserModel>> getUser() async {
    String getUserQuery;

    getUserQuery = r'''
      query GetUser {
        user {
          id
          phone
          token
        }
      }
    ''';

    final response = await _client.query(QueryOptions(
      document: gql(getUserQuery),
    ));

    if (response.hasException) {
      if (response.exception.toString().contains('Unauthorized')) {
        return DataFailed(
          UnauthorizedRequestFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    final user = response.data!['user'];

    return DataSuccess(UserModel.fromJson(user));
  }

  @override
  Future<DataState<LoginModel>> logout() async {
    String logoutQuery;

    logoutQuery = r'''
      mutation Logout {
        logout
      }
    ''';

    final response = await _client.mutate(MutationOptions(
      document: gql(logoutQuery),
    ));

    if (response.hasException) {
      return DataFailed(
        ServerFailure(
          errorMessage: response.exception.toString(),
        ),
      );
    }

    return DataSuccess(LoginModel(
      id: '',
      accessToken: '',
      refreshToken: '',
    ));
  }

  @override
  Future<bool> isSignedIn() async {
    debugPrint('Checking if user is signed in');
    final String savedAccessToken = await GQLClient.getAccessTokenFromStorage();
    final String savedRefreshToken =
        await GQLClient.getRefreshTokenFromStorage();
    final String savedUserId = await GQLClient.getUserIdFromStorage();

    debugPrint('SavedAccessToken: $savedAccessToken');
    debugPrint('SavedRefreshToken: $savedRefreshToken');
    debugPrint('SavedUserId: $savedUserId');

    bool isSignIn = savedAccessToken.isNotEmpty &&
        savedRefreshToken.isNotEmpty &&
        savedUserId.isNotEmpty;

    debugPrint('IsSignedIn: $isSignIn');
    return isSignIn;
  }

  // save id, access token, refresh token to local storage
  Future<void> saveToLocalStorage(dynamic authData) async {
    await GQLClient.saveToLocalStorage(
      'jwt',
      authData['accessToken'],
    );
    await GQLClient.saveToLocalStorage(
      'refresh_token',
      authData['refreshToken'],
    );

    await GQLClient.saveToLocalStorage(
      'user_id',
      authData['userId'],
    );
  }
}
