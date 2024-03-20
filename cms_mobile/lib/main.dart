import 'package:cms_mobile/core/routes/go_router.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/login/log_in_bloc.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
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
          BlocProvider<LoginBloc>(
            create: (context) => sl<LoginBloc>(),
          ),
          BlocProvider<MaterialRequestBloc>(
            create: (context) => sl<MaterialRequestBloc>(),
          ),
          BlocProvider<MaterialTransactionBloc>(
            create: (context) => sl<MaterialTransactionBloc>(),
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
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == AuthStatus.loading) {
              return const CircularProgressIndicator();
            }
            final appRouter = AppRouter().router;
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'CMS APP',
              routerDelegate: appRouter.routerDelegate,
              routeInformationParser: appRouter.routeInformationParser,
              routeInformationProvider: appRouter.routeInformationProvider,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
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
