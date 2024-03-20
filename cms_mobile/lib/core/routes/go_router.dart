import 'package:cms_mobile/core/routes/error_page.dart';
import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/pages/login_page.dart';
import 'package:cms_mobile/features/home/presentation/pages/HomePage.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter _router;

  AppRouter({Key? key}) {
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
              name: RouteNames.materialRequests,
              path: RoutePaths.materialRequests,
              builder: (BuildContext context, GoRouterState state) {
                return MaterialRequestsPage(
                  itemId: state.pathParameters['itemId']!,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
  GoRouter get router => _router;
}
