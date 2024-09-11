import 'package:cms_mobile/app.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/login/log_in_bloc.dart';
import 'package:cms_mobile/features/home/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_proforma/material_proforma_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive/material_receive_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/material_transfers_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/details/details_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/list/list_cubit.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_bloc.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_event.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:cms_mobile/simple_bloc_observer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const SimpleBlocObserver();

  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    initializeDependencies(),
    EasyLocalization.ensureInitialized(),
  ]).then((value) => runApp(MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (context) => sl<ThemeBloc>(),
          ),
          BlocProvider<AuthBloc>(
              create: (context) => sl<AuthBloc>()..add(AuthStarted())),
          BlocProvider<ProjectBloc>(
              create: (context) =>
                  sl<ProjectBloc>()..add(const LoadProjects())),
          BlocProvider<LoginBloc>(
            create: (context) => sl<LoginBloc>(),
          ),
          BlocProvider<MaterialRequestBloc>(
            create: (context) => sl<MaterialRequestBloc>(),
          ),
          BlocProvider<MaterialReceiveBloc>(
            create: (context) => sl<MaterialReceiveBloc>(),
          ),
          BlocProvider<MaterialTransactionBloc>(
            create: (context) => sl<MaterialTransactionBloc>(),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => sl<DashboardBloc>(),
          ),
          BlocProvider<MaterialIssueBloc>(
            create: (context) => sl<MaterialIssueBloc>(),
          ),
          BlocProvider<MaterialReturnBloc>(
            create: (context) => sl<MaterialReturnBloc>(),
          ),
          BlocProvider<MaterialTransferBloc>(
            create: (context) => sl<MaterialTransferBloc>(),
          ),
          BlocProvider<PurchaseOrderBloc>(
            create: (context) => sl<PurchaseOrderBloc>(),
          ),
          BlocProvider<DailySiteDataBloc>(
            create: (context) => sl<DailySiteDataBloc>(),
          ),
          BlocProvider<MaterialProformaBloc>(
            create: (context) => sl<MaterialProformaBloc>(),
          ),
          BlocProvider<MaterialRequestLocalBloc>(
            create: (context) => sl<MaterialRequestLocalBloc>(),
          ),
          BlocProvider<MaterialReceiveLocalBloc>(
            create: (context) => sl<MaterialReceiveLocalBloc>(),
          ),
          BlocProvider<MaterialIssueLocalBloc>(
            create: (context) => sl<MaterialIssueLocalBloc>(),
          ),
          BlocProvider<MaterialReturnLocalBloc>(
            create: (context) => sl<MaterialReturnLocalBloc>(),
          ),
          BlocProvider<PurchaseOrderLocalBloc>(
            create: (context) => sl<PurchaseOrderLocalBloc>(),
          ),
          BlocProvider<DailySiteDataLocalBloc>(
            create: (context) => sl<DailySiteDataLocalBloc>(),
          ),
          BlocProvider<WarehouseBloc>(
            create: (context) => sl<WarehouseBloc>(),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => sl<ProductBloc>(),
          ),
          BlocProvider<PurchaseOrderBloc>(
            create: (context) => sl<PurchaseOrderBloc>(),
          ),
          BlocProvider<MilestonesCubit>(
            create: (context) => sl<MilestonesCubit>(),
          ),
          BlocProvider<MilestoneDetailsCubit>(
            create: (context) => sl<MilestoneDetailsCubit>(),
          ),
        ],
        child: EasyLocalization(
          path: 'assets/translations',
          startLocale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          supportedLocales: const [Locale('en', 'US'), Locale('am', 'ET')],
          child: const MyApp(),
        ),
      )));
}
