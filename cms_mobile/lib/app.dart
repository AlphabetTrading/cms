import 'package:cms_mobile/core/routes/go_router.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/pages/login_page.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_event.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_state.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:cms_mobile/features/theme/bloc/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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
