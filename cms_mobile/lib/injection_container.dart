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
import 'package:cms_mobile/features/material_transactions/data/data_source/material_receive/material_receive_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_transfer/material_transfer_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/purchase_order/purchase_order_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/material_receive_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/material_transfer_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/purchase_order_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_receive_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_transfer_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/create_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/delete_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/get_material_issue_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/get_material_issues.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/create_material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/delete_material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/get_material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/get_material_receive_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/create_material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/get_material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/get_material_request_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/get_material_requests.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_return/get_material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/create_material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/delete_material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/get_material_transfer_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/get_material_transfers.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/create_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/delete_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/edit_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/get_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/get_purchase_order_details.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/delete/delete_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/delete/delete_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/material_transfers_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/delete/delete_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_bloc.dart';
import 'package:cms_mobile/features/products/domain/usecases/get_all_warehouse_products.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issues/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_requests/material_request_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_return/material_return_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/material_issue_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/material_request_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/material_return_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_return_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_return/create_material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/delete/delete_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_issue_form/material_issue_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_request_form/material_request_form_cubit.dart';
import 'package:cms_mobile/features/products/data/data_sources/remote_data_source.dart';
import 'package:cms_mobile/features/products/data/repository/product_repository_impl.dart';
import 'package:cms_mobile/features/products/domain/repository/product_repository.dart';
import 'package:cms_mobile/features/products/domain/usecases/get_products.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/projects/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/projects/data/repository/project_repository_impl.dart';
import 'package:cms_mobile/features/projects/domain/repository/project_repository.dart';
import 'package:cms_mobile/features/projects/domain/usecases/get_project_issue.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_return_form/material_return_form_cubit.dart';
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

  /**
   * data source
   */

  // authentication
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

  // material issue
  sl.registerLazySingleton<MaterialIssueDataSource>(
    () => MaterialIssueDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // material request
  sl.registerLazySingleton<MaterialRequestDataSource>(
    () => MaterialRequestDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // material receive
  sl.registerLazySingleton<MaterialReceiveDataSource>(
    () => MaterialReceiveDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // material return
  sl.registerLazySingleton<MaterialReturnDataSource>(
    () => MaterialReturnDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // material transfer
  sl.registerLazySingleton<MaterialTransferDataSource>(
    () => MaterialTransferDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // purchase order
  sl.registerLazySingleton<PurchaseOrderDataSource>(
    () => PurchaseOrderDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // warehouse
  sl.registerLazySingleton<WarehouseDataSource>(
    () => WarehouseDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // product
  sl.registerLazySingleton<ProductDataSource>(
    () => ProductDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // project
  sl.registerLazySingleton<ProjectDataSource>(
    () => ProjectDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  /**
   * repository
   */

  // authentication
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            dataSource: sl<AuthenticationRemoteDataSource>(),
          ));

  // material transactions
  sl.registerLazySingleton<MaterialTransactionRepository>(
    () => MaterialTransactionRepositoryImpl(
      dataSource: sl<MaterialTransactionsDataSource>(),
    ),
  );

  // material issue
  sl.registerLazySingleton<MaterialIssueRepository>(
    () =>
        MaterialIssueRepositoryImpl(dataSource: sl<MaterialIssueDataSource>()),
  );

  // material request
  sl.registerLazySingleton<MaterialRequestRepository>(
    () => MaterialRequestRepositoryImpl(
        dataSource: sl<MaterialRequestDataSource>()),
  );

  // material receive
  sl.registerLazySingleton<MaterialReceiveRepository>(
    () => MaterialReceiveRepositoryImpl(
        dataSource: sl<MaterialReceiveDataSource>()),
  );

  // material return
  sl.registerLazySingleton<MaterialReturnRepository>(
    () => MaterialReturnRepositoryImpl(
        dataSource: sl<MaterialReturnDataSource>()),
  );

  // purchase order
  sl.registerLazySingleton<PurchaseOrderRepository>(
    () =>
        PurchaseOrderRepositoryImpl(dataSource: sl<PurchaseOrderDataSource>()),
  );

  // material transfer
  sl.registerLazySingleton<MaterialTransferRepository>(
    () => MaterialTransferRepositoryImpl(
      dataSource: sl<MaterialTransferDataSource>(),
    ),
  );

  // warehouse
  sl.registerLazySingleton<WarehouseRepository>(
    () => WarehouseRepositoryImpl(dataSource: sl<WarehouseDataSource>()),
  );

  // product
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(dataSource: sl<ProductDataSource>()),
  );

  // project
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      dataSource: sl<ProjectDataSource>(),
    ),
  );

  /**
   * use cases
   */

  // authentication
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

  // material request
  sl.registerLazySingleton<GetMaterialRequestUseCase>(
    () => GetMaterialRequestUseCase(
      sl<MaterialTransactionRepository>(),
    ),
  );
  sl.registerLazySingleton<GetMaterialRequestDetailsUseCase>(
    () => GetMaterialRequestDetailsUseCase(
      sl<MaterialRequestRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMaterialRequestsUseCase>(
    () => GetMaterialRequestsUseCase(
      sl<MaterialRequestRepository>(),
    ),
  );

  // material receive
  sl.registerLazySingleton<GetMaterialReceivesUseCase>(
    () => GetMaterialReceivesUseCase(
      sl<MaterialReceiveRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMaterialReceiveDetailsUseCase>(
    () => GetMaterialReceiveDetailsUseCase(
      sl<MaterialReceiveRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateMaterialReceiveUseCase>(
    () => CreateMaterialReceiveUseCase(
      sl<MaterialReceiveRepository>(),
    ),
  );

  sl.registerLazySingleton<DeleteMaterialReceiveUseCase>(
    () => DeleteMaterialReceiveUseCase(
      sl<MaterialReceiveRepository>(),
    ),
  );

  // material transaction
  sl.registerLazySingleton<GetMaterialTransactionUseCase>(
    () => GetMaterialTransactionUseCase(
      sl<MaterialTransactionRepository>(),
    ),
  );

  // material issue
  sl.registerLazySingleton<GetMaterialIssuesUseCase>(
    () => GetMaterialIssuesUseCase(
      sl<MaterialIssueRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMaterialIssueDetailsUseCase>(
    () => GetMaterialIssueDetailsUseCase(
      sl<MaterialIssueRepository>(),
    ),
  );
  sl.registerLazySingleton<DeleteMaterialIssueUseCase>(
    () => DeleteMaterialIssueUseCase(
      sl<MaterialIssueRepository>(),
    ),
  );

  // warehouses & products
  sl.registerLazySingleton<GetWarehousesUseCase>(
    () => GetWarehousesUseCase(
      sl<WarehouseRepository>(),
    ),
  );

  // products
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(
      sl<ProductRepository>(),
    ),
  );

  sl.registerLazySingleton<GetAllWarehouseProductsUseCase>(
    () => GetAllWarehouseProductsUseCase(
      sl<ProductRepository>(),
    ),
  );

  // projects

  sl.registerLazySingleton<CreateMaterialRequestUseCase>(
    () => CreateMaterialRequestUseCase(
      sl<MaterialRequestRepository>(),
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
      SelectProjectUseCase(sl<ProjectRepository>()));

  sl.registerLazySingleton<CreateMaterialIssueUseCase>(
    () => CreateMaterialIssueUseCase(
      sl<MaterialIssueRepository>(),
    ),
  );

  // purchase order

  sl.registerLazySingleton<GetPurchaseOrdersUseCase>(
    () => GetPurchaseOrdersUseCase(
      sl<PurchaseOrderRepository>(),
    ),
  );

  sl.registerLazySingleton<GetPurchaseOrderDetailsUseCase>(
    () => GetPurchaseOrderDetailsUseCase(
      sl<PurchaseOrderRepository>(),
    ),
  );

  sl.registerLazySingleton<CreatePurchaseOrderUseCase>(
    () => CreatePurchaseOrderUseCase(
      sl<PurchaseOrderRepository>(),
    ),
  );

  sl.registerLazySingleton<EditPurchaseOrderUseCase>(
    () => EditPurchaseOrderUseCase(
      sl<PurchaseOrderRepository>(),
    ),
  );

  sl.registerLazySingleton<DeletePurchaseOrderUseCase>(
    () => DeletePurchaseOrderUseCase(
      sl<PurchaseOrderRepository>(),
    ),
  );

  // material return
  sl.registerLazySingleton<GetMaterialReturnUseCase>(
    () => GetMaterialReturnUseCase(
      sl<MaterialReturnRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateMaterialReturnUseCase>(
    () => CreateMaterialReturnUseCase(
      sl<MaterialReturnRepository>(),
    ),
  );

  // material transfer
  sl.registerLazySingleton<GetMaterialTransfersUseCase>(
    () => GetMaterialTransfersUseCase(
      sl<MaterialTransferRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateMaterialTransferUseCase>(
    () => CreateMaterialTransferUseCase(
      sl<MaterialTransferRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMaterialTransferDetailsUseCase>(
    () => GetMaterialTransferDetailsUseCase(
      sl<MaterialTransferRepository>(),
    ),
  );

  sl.registerLazySingleton<DeleteMaterialTransferUseCase>(
    () => DeleteMaterialTransferUseCase(
      sl<MaterialTransferRepository>(),
    ),
  );

  // bloc

  // sl.registerFactory(() => ThemeBloc(prefUtils: sl<PrefUtils>()));
  sl.registerFactory(() => ThemeBloc());

  // auth bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        isSignedInUseCase: sl<IsSignedInUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        getUserUseCase: sl<GetUserUseCase>(),
      ));

  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl<LoginUseCase>()),
  );

  // material transaction
  sl.registerFactory<MaterialTransactionBloc>(
    () => MaterialTransactionBloc(sl<GetMaterialTransactionUseCase>()),
  );

  // material request
  sl.registerFactory<MaterialRequestBloc>(() => MaterialRequestBloc(
      sl<GetMaterialRequestsUseCase>(), sl<CreateMaterialRequestUseCase>()));

  sl.registerFactory<MaterialRequestLocalBloc>(
    () => MaterialRequestLocalBloc(),
  );

  sl.registerFactory<MaterialRequestDetailsCubit>(
    () => MaterialRequestDetailsCubit(sl<GetMaterialRequestDetailsUseCase>()),
  );
  sl.registerFactory<MaterialRequestFormCubit>(
    () => MaterialRequestFormCubit(),
  );

  // material issue
  sl.registerFactory<MaterialIssueBloc>(
    () => MaterialIssueBloc(
        sl<GetMaterialIssuesUseCase>(), sl<CreateMaterialIssueUseCase>()),
  );

  sl.registerFactory<MaterialIssueDetailsCubit>(
    () => MaterialIssueDetailsCubit(sl<GetMaterialIssueDetailsUseCase>()),
  );

  sl.registerFactory<MaterialIssueDeleteCubit>(
    () => MaterialIssueDeleteCubit(sl<DeleteMaterialIssueUseCase>()),
  );

  sl.registerFactory<MaterialIssueLocalBloc>(
    () => MaterialIssueLocalBloc(),
  );

  sl.registerFactory<MaterialIssueFormCubit>(
    () => MaterialIssueFormCubit(),
  );

  // material receive
  sl.registerFactory<MaterialReceiveBloc>(
    () => MaterialReceiveBloc(
        sl<GetMaterialReceivesUseCase>(),
        sl<CreateMaterialReceiveUseCase>(),
        sl<GetMaterialReceiveDetailsUseCase>()),
  );

  sl.registerFactory<MaterialReceiveDetailsCubit>(
    () => MaterialReceiveDetailsCubit(
      sl<GetMaterialReceiveDetailsUseCase>(),
    ),
  );

  sl.registerFactory<MaterialReceiveDeleteCubit>(
    () => MaterialReceiveDeleteCubit(sl<DeleteMaterialReceiveUseCase>()),
  );

  // material return
  sl.registerFactory<MaterialReturnBloc>(
    () => MaterialReturnBloc(
        sl<CreateMaterialReturnUseCase>(), sl<GetMaterialReturnUseCase>()),
  );

  sl.registerFactory<MaterialReturnLocalBloc>(
    () => MaterialReturnLocalBloc(),
  );

  sl.registerFactory<MaterialReturnFormCubit>(
    () => MaterialReturnFormCubit(),
  );

  // warehouse & products bloc
  sl.registerFactory<WarehouseBloc>(
    () => WarehouseBloc(sl<GetWarehousesUseCase>()),
  );
  sl.registerFactory<ProductBloc>(
    () => ProductBloc(
        sl<GetProductsUseCase>(), sl<GetAllWarehouseProductsUseCase>()),
  );

  // project bloc
  sl.registerFactory<ProjectBloc>(
    () => ProjectBloc(sl<GetProjectsUseCase>(), sl<GetSelectedProjectUseCase>(),
        sl<SelectProjectUseCase>()),
  );

  // purchase order
  sl.registerFactory<PurchaseOrderBloc>(
    () => PurchaseOrderBloc(sl<GetPurchaseOrdersUseCase>()),
  );

  sl.registerFactory<PurchaseOrderDetailsCubit>(
    () => PurchaseOrderDetailsCubit(
      sl<GetPurchaseOrderDetailsUseCase>(),
    ),
  );

  sl.registerFactory<PurchaseOrderDeleteCubit>(
    () => PurchaseOrderDeleteCubit(sl<DeletePurchaseOrderUseCase>()),
  );

  // material transfer
  sl.registerFactory<MaterialTransferBloc>(
    () => MaterialTransferBloc(
      sl<GetMaterialTransfersUseCase>(),
      sl<CreateMaterialTransferUseCase>(),
      sl<GetMaterialTransferDetailsUseCase>(),
    ),
  );

  sl.registerFactory<MaterialTransferDetailsCubit>(
    () => MaterialTransferDetailsCubit(
      sl<GetMaterialTransferDetailsUseCase>(),
    ),
  );

  sl.registerFactory<MaterialTransferDeleteCubit>(
    () => MaterialTransferDeleteCubit(
      sl<DeleteMaterialTransferUseCase>(),
    ),
  );
}
