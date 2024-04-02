import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/pages/login_page.dart';
import 'package:cms_mobile/features/home/presentation/pages/HomePage.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issues.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_requests.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/purchase_orders.dart';
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
            (state.matchedLocation == RouteNames.login ||
                state.matchedLocation == RouteNames.forgotPassword ||
                state.matchedLocation == RouteNames.resetPassword ||
                state.matchedLocation == RouteNames.signup)) {
          return RouteNames.home;
        }
        if (!isAuthenticated && state.path == RouteNames.login ||
            state.matchedLocation == RouteNames.forgotPassword ||
            state.matchedLocation == RouteNames.resetPassword ||
            state.matchedLocation == RouteNames.signup) {
          return state.matchedLocation;
        }

        if (!isAuthenticated) {
          return RouteNames.login;
        }

        if (isAuthenticated) {
          return state.matchedLocation;
        }
        return RouteNames.home;
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
            ),
            GoRoute(
              name: RouteNames.materialRequest,
              path: RoutePaths.materialRequest,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialRequestsPage();
              },
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
