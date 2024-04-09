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
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_material_requests.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_request_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_request_form_state.dart';
import 'package:cms_mobile/features/items/data/data_sources/remote_data_source.dart';
import 'package:cms_mobile/features/items/data/repository/item_repository_impl.dart';
import 'package:cms_mobile/features/items/domain/repository/item_repository.dart';
import 'package:cms_mobile/features/items/domain/usecases/get_items.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_bloc.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:cms_mobile/features/warehouse/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/warehouse/data/repository/warehouse_repository_impl.dart';
import 'package:cms_mobile/features/warehouse/domain/repository/warehouse_repository.dart';
import 'package:cms_mobile/features/warehouse/domain/usecases/get_warehouses.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
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

  sl.registerLazySingleton<VoucherDataSourceImpl>(
    () => VoucherDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  sl.registerLazySingleton<WarehouseDataSourceImpl>(
    () => WarehouseDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );
  sl.registerLazySingleton<ItemDataSourceImpl>(
    () => ItemDataSourceImpl(
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

  sl.registerLazySingleton<WarehouseRepository>(
    () => WarehouseRepositoryImpl(dataSource: sl<WarehouseDataSourceImpl>()),
  );

  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(dataSource: sl<ItemDataSourceImpl>()),
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

  sl.registerLazySingleton<GetWarehousesUseCase>(
    () => GetWarehousesUseCase(
      sl<WarehouseRepository>(),
    ),
  );

  sl.registerLazySingleton<GetItemsUseCase>(
    () => GetItemsUseCase(
      sl<ItemRepository>(),
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

  sl.registerFactory<MaterialRequestLocalBloc>(
    () => MaterialRequestLocalBloc(),
  );

  sl.registerFactory<MaterialRequestFormCubit>(
    () => MaterialRequestFormCubit(),
  );

  sl.registerFactory<WarehouseBloc>(
    () => WarehouseBloc(sl<GetWarehousesUseCase>()),
  );
  sl.registerFactory<ItemBloc>(
    () => ItemBloc(sl<GetItemsUseCase>()),
  );
}
