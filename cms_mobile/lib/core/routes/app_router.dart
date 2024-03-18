import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/pages/login_page.dart';
import 'package:cms_mobile/features/home/presentation/pages/HomePage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter extends StatelessWidget {
  late final GoRouter _router;

  AppRouter({Key? key}) : super(key: key) {
    _router = GoRouter(
        initialLocation: RouteNames.homePage,
        routes: routes,
        redirect: (context, state) {
          // final authState = context.read<AuthBloc>().state.status;
          // final isAuthenticated = authState == AuthStatus.signedIn;
          // if (isAuthenticated &&
          //     (state.matchedLocation == RouteNames.loginRoute ||
          //         state.matchedLocation == RouteNames.forgotPasswordRoute ||
          //         state.matchedLocation == RouteNames.resetPasswordRoute ||
          //         state.matchedLocation == RouteNames.signupRoute)) {
          //   return RouteNames.homePage;
          // }
          // if (!isAuthenticated && state.path == RouteNames.loginRoute ||
          //     state.matchedLocation == RouteNames.forgotPasswordRoute ||
          //     state.matchedLocation == RouteNames.resetPasswordRoute ||
          //     state.matchedLocation == RouteNames.signupRoute) {
          //   return state.matchedLocation;
          // }

          // if (!isAuthenticated) {
          //   return RouteNames.loginRoute;
          // }

          // if (isAuthenticated) {
          //   return state.matchedLocation;
          // }

          return RouteNames.homePage;
        });
  }

  final routes = <GoRoute>[
    GoRoute(
      path: RouteNames.homePage,
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    ),
    GoRoute(
      path: RouteNames.loginRoute,
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    String fontFamily;
    if (context.locale.languageCode == 'en') {
      fontFamily = 'Poppins';
    } else if (context.locale.languageCode == 'am') {
      fontFamily = 'NotoSansEthiopic';
    } else {
      fontFamily = 'Miama';
    }

    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}

String getAuthenticationRouteName(String route) {
  debugPrint('Route: $route');
  return switch (route) {
    RouteNames.loginRoute => RouteNames.loginRoute,
    RouteNames.forgotPasswordRoute => RouteNames.forgotPasswordRoute,
    RouteNames.resetPasswordRoute => RouteNames.resetPasswordRoute,
    _ => RouteNames.signupRoute
  };
}
