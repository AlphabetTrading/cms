import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/pages/login_page.dart';
import 'package:cms_mobile/features/home/presentation/pages/HomePage.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issue/material_issue_create.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issue/material_issue_details.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issue/material_issue_edit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_request/create_material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issues.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_request/material_request_details.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_requests.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/purchase_orders.dart';
import 'package:cms_mobile/features/items/presentation/pages/ItemsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter _router;

  AppRouter({Key? key}) {
    debugPrint('AppRouter');
    _router = GoRouter(
      initialLocation: RoutePaths.home,
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state.status;
        final isAuthenticated = authState == AuthStatus.signedIn;
        if (isAuthenticated &&
            (state.matchedLocation == '/${RoutePaths.login}' ||
                state.matchedLocation == '/${RoutePaths.forgotPassword}' ||
                state.matchedLocation == '/${RoutePaths.resetPassword}' ||
                state.matchedLocation == '/${RoutePaths.signup}')) {
          return RoutePaths.home;
        }
        if (!isAuthenticated && state.path == '/${RoutePaths.login}' ||
            state.matchedLocation == '/${RoutePaths.forgotPassword}' ||
            state.matchedLocation == '/${RoutePaths.resetPassword}' ||
            state.matchedLocation == '/${RoutePaths.signup}') {
          return state.matchedLocation;
        }

        if (!isAuthenticated) {
          return '/${RoutePaths.login}';
        }

        if (isAuthenticated) {
          return state.matchedLocation;
        }
        return RoutePaths.home;
      },
      routes: <RouteBase>[
        GoRoute(
          name: RouteNames.home,
          path: RoutePaths.home,
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
          routes: <RouteBase>[
            GoRoute(
              name: RouteNames.items,
              path: RoutePaths.items,
              builder: (BuildContext context, GoRouterState state) {
                return ItemsPage(
                  warehouseId: state.pathParameters['warehouseId']!,
                );
              },
            ),
            GoRoute(
                name: RouteNames.login,
                path: RoutePaths.login,
                builder: (BuildContext context, GoRouterState state) {
                  return const LoginPage();
                }),
            GoRoute(
              name: RouteNames.materialIssue,
              path: RoutePaths.materialIssue,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialIssuesPage();
              },
              routes: <RouteBase>[
                GoRoute(
                  name: RouteNames.materialIssueCreate,
                  path: RoutePaths.materialIssueCreate,
                  builder: (BuildContext context, GoRouterState state) {
                    return const MaterialIssueCreatePage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialIssueDetails,
                  path: RoutePaths.materialIssueDetails,
                  builder: (BuildContext context, GoRouterState state) {
                    return MaterialIssueDetailsPage(
                        materialIssueId:
                            state.pathParameters['materialIssueId']!);
                  },
                ),
                GoRoute(
                  name: RouteNames.materialIssueEdit,
                  path: RoutePaths.materialIssueEdit,
                  builder: (BuildContext context, GoRouterState state) {
                    return const MaterialIssueEditPage();
                  },
                ),
              ],
            ),
            GoRoute(
              name: RouteNames.materialRequests,
              path: RoutePaths.materialRequests,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialRequestsPage();
              },
              routes: <RouteBase>[
                GoRoute(
                  name: RouteNames.materialRequestCreate,
                  path: RoutePaths.materialRequestCreate,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialRequestEdit,
                  path: RoutePaths.materialRequestEdit,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialRequestDetails,
                  path: RoutePaths.materialRequestDetails,
                  builder: (BuildContext context, GoRouterState state) {
                    return const MaterialRequestDetailsPage();
                  },
                ),
              ],
            ),
            GoRoute(
              name: RouteNames.materialReceiving,
              path: RoutePaths.materialReceiving,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialReceivingPage();
              },
            ),
            GoRoute(
              name: RouteNames.materialReturn,
              path: RoutePaths.materialReturn,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialReturnsPage();
              },
            ),
            GoRoute(
              name: RouteNames.purchaseOrder,
              path: RoutePaths.purchaseOrder,
              builder: (BuildContext context, GoRouterState state) {
                return const PurchaseOrdersPage();
              },
            ),
          ],
        ),
      ],
    );
  }
  GoRouter get router => _router;
}
