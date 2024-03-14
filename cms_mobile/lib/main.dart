import 'package:cms_mobile/core/routes/app_router.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/login/log_in_bloc.dart';
import 'package:cms_mobile/features/material_requests/presentations/bloc/material_requests/material_receiving_bloc.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        ],
        child: EasyLocalization(
            path: 'translations',
            startLocale: const Locale('en', 'US'),
            fallbackLocale: const Locale('en', 'US'),
            supportedLocales: const [Locale('en', 'US'), Locale('am', 'ET')],
            child: const MyApp()),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == AuthStatus.loading) {
          return const CircularProgressIndicator();
        }
        return MaterialApp(
          title: 'CMS',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          home: AppRouter(),
        );
      },
    );
  }
}
