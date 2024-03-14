import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/utils/pref_utils.dart';
import 'package:cms_mobile/features/authentication/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/authentication/data/repository/authentication_repository_impl.dart';
import 'package:cms_mobile/features/authentication/domain/repository/authentication_repository.dart';
import 'package:cms_mobile/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/login/log_in_bloc.dart';
import 'package:cms_mobile/features/material_requests/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/material_requests/data/repository/material_receiving_repository_impl.dart';
import 'package:cms_mobile/features/material_requests/domain/repository/material_request_repository.dart';
import 'package:cms_mobile/features/material_requests/domain/usecases/get_material_requests.dart';
import 'package:cms_mobile/features/material_requests/presentations/bloc/material_requests/material_receiving_bloc.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton(() => PrefUtils());
  // graphql client
  sl.registerLazySingleton<GraphQLClient>(() => GQLClient.client.value);

  // data source
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  sl.registerLazySingleton<MaterialReceivingDataSource>(
    () => MaterialReceivingDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // repository

  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            dataSource: sl<AuthenticationRemoteDataSource>(),
          ));

  sl.registerLazySingleton<MaterialReceivingRepository>(
    () => MaterialReceivingRepositoryImpl(
      dataSource: sl<MaterialReceivingDataSourceImpl>(),
    ),
  );

  // usecase

  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      sl<AuthenticationRepository>(),
    ),
  );

  sl.registerLazySingleton<IsSignedInUseCase>(
    () => IsSignedInUseCase(
      sl<AuthenticationRepository>(),
    ),
  );

  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(
      sl<AuthenticationRepository>(),
    ),
  );

  sl.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(
      sl<AuthenticationRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMaterialRequestUseCase>(
    () => GetMaterialRequestUseCase(
      sl<MaterialReceivingRepository>(),
    ),
  );

  // bloc

  sl.registerFactory(() => ThemeBloc(prefUtils: sl<PrefUtils>()));

  sl.registerFactory<AuthBloc>(() => AuthBloc(
        isSignedInUseCase: sl<IsSignedInUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        getUserUseCase: sl<GetUserUseCase>(),
      ));

  sl.registerFactory<MaterialRequestBloc>(
      () => MaterialRequestBloc(sl<GetMaterialRequestUseCase>()));

  sl.registerFactory<LoginBloc>(
    () => LoginBloc(
      sl<LoginUseCase>()
    ),
  );
}
