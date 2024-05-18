import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/utils/pref_utils.dart';
import 'package:cms_mobile/features/authentication/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/authentication/data/repository/authentication_repository_impl.dart';
import 'package:cms_mobile/features/authentication/domain/repository/authentication_repository.dart';
import 'package:cms_mobile/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/login/log_in_bloc.dart';
import 'package:cms_mobile/features/home/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/home/data/repository/material_transactions_repository_impl.dart';
import 'package:cms_mobile/features/home/domain/repository/material_transaction_repository.dart';
import 'package:cms_mobile/features/home/domain/usecases/get_material_transactions.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/vouchers_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/vouchers_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_requests.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/projects/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/projects/data/repository/project_repository_impl.dart';
import 'package:cms_mobile/features/projects/domain/repository/project_repository.dart';
import 'package:cms_mobile/features/projects/domain/usecases/get_project_issue.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
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

  sl.registerLazySingleton<MaterialTransactionsDataSource>(
    () => MaterialTransactionsDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  sl.registerLazySingleton<VoucherDataSource>(
    () => VoucherDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  sl.registerLazySingleton<ProjectDataSource>(
    () => ProjectDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // repository
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            dataSource: sl<AuthenticationRemoteDataSource>(),
          ));

  sl.registerLazySingleton<MaterialTransactionRepository>(
    () => MaterialTransactionRepositoryImpl(
      dataSource: sl<MaterialTransactionsDataSource>(),
    ),
  );

  sl.registerLazySingleton<VouchersRepository>(
    () => VoucherRepositoryImpl(dataSource: sl<VoucherDataSourceImpl>()),
  );

  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      dataSource: sl<ProjectDataSource>(),
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
      sl<MaterialTransactionRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMaterialTransactionUseCase>(
    () => GetMaterialTransactionUseCase(
      sl<MaterialTransactionRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMaterialIssuesUseCase>(
    () => GetMaterialIssuesUseCase(
      sl<VouchersRepository>(),
    ),
  );

  sl.registerLazySingleton<GetProjectsUseCase>(
    () => GetProjectsUseCase(
      sl<ProjectRepository>(),
    ),
  );

  sl.registerLazySingleton<GetSelectedProjectUseCase>(
    () => GetSelectedProjectUseCase(
      sl<ProjectRepository>(),
    ),
  );

  sl.registerSingleton<SelectProjectUseCase>(
    SelectProjectUseCase(
      sl<ProjectRepository>(),
    ),
  );

  // bloc

  // sl.registerFactory(() => ThemeBloc(prefUtils: sl<PrefUtils>()));
  sl.registerFactory(() => ThemeBloc());

  sl.registerFactory<AuthBloc>(() => AuthBloc(
        isSignedInUseCase: sl<IsSignedInUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        getUserUseCase: sl<GetUserUseCase>(),
      ));

  sl.registerFactory<MaterialRequestBloc>(
      () => MaterialRequestBloc(sl<GetMaterialRequestUseCase>()));

  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl<LoginUseCase>()),
  );

  sl.registerFactory<MaterialTransactionBloc>(
    () => MaterialTransactionBloc(sl<GetMaterialTransactionUseCase>()),
  );

  sl.registerFactory<MaterialIssueBloc>(
    () => MaterialIssueBloc(sl<GetMaterialIssuesUseCase>()),
  );

  sl.registerFactory<ProjectBloc>(
    () => ProjectBloc(sl<GetProjectsUseCase>(),
       sl<GetSelectedProjectUseCase>(),
        sl<SelectProjectUseCase>()),
  );
}
