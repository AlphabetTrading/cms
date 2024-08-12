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
import 'package:cms_mobile/features/material_transactions/data/data_source/daily_site_data/daily_site_data_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_proformas/material_proforma_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_receive/material_receive_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_transfer/material_transfer_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/purchase_order/purchase_order_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/daily_site_data_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/material_proforma_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/material_receive_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/material_transfer_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/data/repository/purchase_order_repository_impl.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/daily_site_data_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_proforma_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_receive_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_transfer_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/create_daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/delete_daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/edit_daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/get_daily_site_data_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/get_daily_site_datas.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/create_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/delete_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/get_material_issue_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/get_material_issues.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/create_material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/delete_material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/edit_material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/get_material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/get_material_proforma_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/create_material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/delete_material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/get_material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/get_material_receive_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/create_material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/delete_material_request.dart';
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
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/delete/delete_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/create/create_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/delete/delete_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/create/create_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/delete/delete_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/delete/delete_cubit.dart';
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
import 'package:cms_mobile/features/progress/data/data_source/milestone_remote_data_source.dart';
import 'package:cms_mobile/features/progress/data/data_source/task_remote_data_source.dart';
import 'package:cms_mobile/features/progress/data/repository/milestone_repository_impl.dart';
import 'package:cms_mobile/features/progress/data/repository/task_repository_impl.dart';
import 'package:cms_mobile/features/progress/domain/repository/milestone_repository.dart';
import 'package:cms_mobile/features/progress/domain/repository/task_repository.dart';
import 'package:cms_mobile/features/progress/domain/usecases/create_milestone.dart';
import 'package:cms_mobile/features/progress/domain/usecases/create_task.dart';
import 'package:cms_mobile/features/progress/domain/usecases/delete_milestone.dart';
import 'package:cms_mobile/features/progress/domain/usecases/delete_task.dart';
import 'package:cms_mobile/features/progress/domain/usecases/edit_milestone.dart';
import 'package:cms_mobile/features/progress/domain/usecases/edit_task.dart';
import 'package:cms_mobile/features/progress/domain/usecases/get_milestone_details.dart';
import 'package:cms_mobile/features/progress/domain/usecases/get_milestones.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/create/create_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/delete/delete_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/details/details_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/edit/edit_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/list/list_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/task/create/create_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/task/delete/delete_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/task/edit/edit_cubit.dart';
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

  // material proforma
  sl.registerLazySingleton<MaterialProformaDataSource>(
    () => MaterialProformaDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // daily site data
  sl.registerLazySingleton<DailySiteDataDataSource>(
    () => DailySiteDataDataSourceImpl(
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

  // progress
  sl.registerLazySingleton<MilestoneDataSource>(
    () => MilestoneDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );
  sl.registerLazySingleton<TaskDataSource>(
    () => TaskDataSourceImpl(
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

  // material proforma
  sl.registerLazySingleton<MaterialProformaRepository>(
    () => MaterialProformaRepositoryImpl(
      dataSource: sl<MaterialProformaDataSource>(),
    ),
  );

  // daily site data
  sl.registerLazySingleton<DailySiteDataRepository>(
    () => DailySiteDataRepositoryImpl(
      dataSource: sl<DailySiteDataDataSource>(),
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
  // progress
  sl.registerLazySingleton<MilestoneRepository>(
    () => MilestoneRepositoryImpl(
      dataSource: sl<MilestoneDataSource>(),
    ),
  );

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      dataSource: sl<TaskDataSource>(),
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
  sl.registerLazySingleton<DeleteMaterialRequestUseCase>(
    () => DeleteMaterialRequestUseCase(
      sl<MaterialRequestRepository>(),
    ),
  );

  // material proforma
  sl.registerLazySingleton<GetMaterialProformasUseCase>(
    () => GetMaterialProformasUseCase(
      sl<MaterialProformaRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateMaterialProformaUseCase>(
    () => CreateMaterialProformaUseCase(
      sl<MaterialProformaRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMaterialProformaDetailsUseCase>(
    () => GetMaterialProformaDetailsUseCase(
      sl<MaterialProformaRepository>(),
    ),
  );

  sl.registerLazySingleton<EditMaterialProformaUseCase>(
    () => EditMaterialProformaUseCase(
      sl<MaterialProformaRepository>(),
    ),
  );

  sl.registerLazySingleton<DeleteMaterialProformaUseCase>(
    () => DeleteMaterialProformaUseCase(
      sl<MaterialProformaRepository>(),
    ),
  );

  // daily site data
  sl.registerLazySingleton<GetDailySiteDatasUseCase>(
    () => GetDailySiteDatasUseCase(
      sl<DailySiteDataRepository>(),
    ),
  );

  sl.registerLazySingleton<GetDailySiteDataDetailsUseCase>(
    () => GetDailySiteDataDetailsUseCase(
      sl<DailySiteDataRepository>(),
    ),
  );

  sl.registerLazySingleton<EditDailySiteDataUseCase>(
    () => EditDailySiteDataUseCase(
      sl<DailySiteDataRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateDailySiteDataUseCase>(
    () => CreateDailySiteDataUseCase(
      sl<DailySiteDataRepository>(),
    ),
  );

  sl.registerLazySingleton<DeleteDailySiteDataUseCase>(
    () => DeleteDailySiteDataUseCase(
      sl<DailySiteDataRepository>(),
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
          ));

  // progress
  sl.registerLazySingleton<GetMilestonesUseCase>(
    () => GetMilestonesUseCase(
      sl<MilestoneRepository>(),
    ),
  );
  sl.registerLazySingleton<GetMilestoneDetailsUseCase>(
    () => GetMilestoneDetailsUseCase(
      sl<MilestoneRepository>(),
    ),
  );
  sl.registerLazySingleton<CreateMilestoneUseCase>(
    () => CreateMilestoneUseCase(
      sl<MilestoneRepository>(),
    ),
  );
  sl.registerLazySingleton<EditMilestoneUseCase>(
    () => EditMilestoneUseCase(
      sl<MilestoneRepository>(),
    ),
  );
  sl.registerLazySingleton<DeleteMilestoneUseCase>(
    () => DeleteMilestoneUseCase(
      sl<MilestoneRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateTaskUseCase>(
    () => CreateTaskUseCase(
      sl<TaskRepository>(),
    ),
  );
  sl.registerLazySingleton<EditTaskUseCase>(
    () => EditTaskUseCase(
      sl<TaskRepository>(),
    ),
  );
  sl.registerLazySingleton<DeleteTaskUseCase>(
    () => DeleteTaskUseCase(
      sl<TaskRepository>(),
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

  sl.registerFactory<DeleteMaterialIssueCubit>(
    () => DeleteMaterialIssueCubit(sl<DeleteMaterialIssueUseCase>()),
  );
  sl.registerFactory<MaterialRequestDeleteCubit>(
    () => MaterialRequestDeleteCubit(sl<DeleteMaterialRequestUseCase>()),
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

  sl.registerFactory<MaterialIssueLocalBloc>(
    () => MaterialIssueLocalBloc(),
  );

  sl.registerFactory<MaterialIssueFormCubit>(
    () => MaterialIssueFormCubit(),
  );

  // material receive
  sl.registerFactory<MaterialReceiveBloc>(
    () => MaterialReceiveBloc(sl<GetMaterialReceivesUseCase>(),
        sl<GetMaterialReceiveDetailsUseCase>()),
  );
    sl.registerFactory<MaterialReceiveLocalBloc>(
    () => MaterialReceiveLocalBloc(),
  );

  sl.registerFactory<CreateMaterialReceiveCubit>(
    () => CreateMaterialReceiveCubit(
      sl<CreateMaterialReceiveUseCase>(),
    ),
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

  // material proforma
  sl.registerFactory<MaterialProformaBloc>(
    () => MaterialProformaBloc(
      sl<GetMaterialProformasUseCase>(),
    )
  );

  sl.registerFactory<MaterialProformaDetailsCubit>(
    () => MaterialProformaDetailsCubit(
      sl<GetMaterialProformaDetailsUseCase>(),
    ),
  );

  sl.registerFactory<DeleteMaterialProformaCubit>(
    () => DeleteMaterialProformaCubit(
      sl<DeleteMaterialProformaUseCase>(),
    ),
  );
    sl.registerFactory<CreateMaterialProformaCubit>(
    () => CreateMaterialProformaCubit(
      sl<CreateMaterialProformaUseCase>(),
    ),
  );

  // daily site data
  sl.registerFactory<DailySiteDataBloc>(
    () => DailySiteDataBloc(
      sl<GetDailySiteDatasUseCase>(),
      sl<CreateDailySiteDataUseCase>(),
    ),
  );

  sl.registerFactory<DailySiteDataLocalBloc>(
    () => DailySiteDataLocalBloc(),
  );

  sl.registerFactory<DailySiteDataDetailsCubit>(
    () => DailySiteDataDetailsCubit(
      sl<GetDailySiteDataDetailsUseCase>(),
    ),
  );

  sl.registerFactory<DeleteDailySiteDataCubit>(
    () => DeleteDailySiteDataCubit(
      sl<DeleteDailySiteDataUseCase>(),
    ),
  );

  // progress
  sl.registerFactory<MilestonesCubit>(
    () => MilestonesCubit(sl<GetMilestonesUseCase>()),
  );
  sl.registerFactory<MilestoneDetailsCubit>(
    () => MilestoneDetailsCubit(sl<GetMilestoneDetailsUseCase>()),
  );
  sl.registerFactory<CreateMilestoneCubit>(
    () => CreateMilestoneCubit(sl<CreateMilestoneUseCase>()),
  );
  sl.registerFactory<EditMilestoneCubit>(
    () => EditMilestoneCubit(sl<EditMilestoneUseCase>()),
  );
  sl.registerFactory<DeleteMilestoneCubit>(
    () => DeleteMilestoneCubit(sl<DeleteMilestoneUseCase>()),
  );

  sl.registerFactory<CreateTaskCubit>(
    () => CreateTaskCubit(sl<CreateTaskUseCase>()),
  );
  sl.registerFactory<EditTaskCubit>(
    () => EditTaskCubit(sl<EditTaskUseCase>()),
  );
  sl.registerFactory<DeleteTaskCubit>(
    () => DeleteTaskCubit(sl<DeleteTaskUseCase>()),
  );
}
