import 'package:cms_mobile/core/routes/go_router.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/login/log_in_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/pages/login_page.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_event.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_bloc.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return/material_return_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_bloc.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:cms_mobile/features/theme/bloc/theme_state.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          BlocProvider<MaterialTransactionBloc>(
            create: (context) => sl<MaterialTransactionBloc>(),
          ),
          BlocProvider<MaterialIssueBloc>(
            create: (context) => sl<MaterialIssueBloc>(),
          ),
          BlocProvider<MaterialReturnBloc>(
            create: (context) => sl<MaterialReturnBloc>(),
          ),
          BlocProvider<MaterialRequestLocalBloc>(
            create: (context) => sl<MaterialRequestLocalBloc>(),
          ),
          BlocProvider<MaterialIssueLocalBloc>(
            create: (context) => sl<MaterialIssueLocalBloc>(),
          ),
          BlocProvider<MaterialReturnLocalBloc>(
            create: (context) => sl<MaterialReturnLocalBloc>(),
          ),
          BlocProvider<WarehouseBloc>(
            create: (context) => sl<WarehouseBloc>(),
          ),
          BlocProvider<ItemBloc>(
            create: (context) => sl<ItemBloc>(),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            final themeData = state.themeData;
            return BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state.status == AuthStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.status == AuthStatus.signedOut) {
                  return const MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: LoginPage(),
                  );
                }

                if (state.status == AuthStatus.signedIn) {
                  final appRouter = AppRouter().router;
                  return BlocConsumer<ProjectBloc, ProjectState>(
                    listener: (context, state) {
                      if (state is ProjectSuccess) {
                        if (state.projects!.items.isNotEmpty) {
                          context.read<ProjectBloc>().add(
                                SelectProject(
                                  state.projects!.items.first.id!,
                                  state.projects!,
                                ),
                              );
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is ProjectIntialLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return MaterialApp.router(
                        debugShowCheckedModeBanner: false,
                        title: 'CMS APP',
                        routerDelegate: appRouter.routerDelegate,
                        routeInformationParser:
                            appRouter.routeInformationParser,
                        routeInformationProvider:
                            appRouter.routeInformationProvider,
                        localizationsDelegates: context.localizationDelegates,
                        supportedLocales: context.supportedLocales,
                        locale: context.locale,
                        theme: themeData,
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        );
      },
    );
  }
}


// final GoRouter _router = GoRouter(
//   initialLocation: '/',
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return const HomePage();
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           name: "material-requests",
//           path: "material-requests/:itemId",
//           builder: (BuildContext context, GoRouterState state) {
//             return MaterialRequestsPage(
//               itemId: state.pathParameters['itemId']!,
//             );
//           },
//         ),
//       ],
//     ),
//   ],
// );
