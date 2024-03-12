import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/utils/pref_utils.dart';
import 'package:cms_mobile/features/material_requests/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton(() => PrefUtils());
  sl.registerFactory(() => ThemeBloc(prefUtils: sl<PrefUtils>()));
  // data source
  sl.registerLazySingleton<MaterialReceivingDataSourceImpl>(
    () => MaterialReceivingDataSourceImpl(
      client: sl<GraphQLClient>(),
    ),
  );

  // sl.registerFactory(() => AuthBloc(authRepository: sl<AuthRepository>()));
  // sl.registerFactory(() => HomeBloc(homeRepository: sl<HomeRepository>()));
  // sl.registerFactory(() => ProfileBloc(profileRepository: sl<ProfileRepository>()));
  // sl.registerFactory(() => NotificationBloc(notificationRepository: sl<NotificationRepository>()));
  // sl.registerFactory(() => ThemeBloc(prefUtils: sl<PrefUtils>()));
  // sl.registerFactory(() => AuthBloc(authRepository: sl<AuthRepository>()));
  // sl.registerFactory(() => HomeBloc(homeRepository: sl<HomeRepository>()));
  // sl.registerFactory(() => ProfileBloc(profileRepository: sl<ProfileRepository>()));
  // sl.registerFactory(() => NotificationBloc(notificationRepository: sl<NotificationRepository>()));
  // sl.registerFactory(() => ThemeBloc(prefUtils: sl<PrefUtils>()));
  // sl.registerFactory(() => AuthBloc(authRepository: sl<AuthRepository>()));
  // sl.registerFactory(() => HomeBloc(homeRepository: sl<HomeRepository>()));
  // sl.registerFactory(() => ProfileBloc(profileRepository: sl<ProfileRepository>()));
  // sl.registerFactory(() => NotificationBloc(notificationRepository: sl<NotificationRepository>()));
  // sl.registerFactory(() => ThemeBloc(prefUtils: sl<PrefUtils>()));
  // sl.registerFactory(() => AuthBloc(authRepository: sl<AuthRepository>()));
  // sl.registerFactory(() => HomeBloc(homeRepository: sl<HomeRepository>()));
  // sl.registerFactory(() => ProfileBloc(profileRepository: sl<ProfileRepository>()));
  // sl.registerFactory(() => NotificationBloc(notificationRepository: sl<NotificationRepository>()));
  // sl.registerFactory(() => ThemeBloc(prefUtils: sl<PrefUtils>()));
  // sl.registerFactory(() => AuthBloc(authRepository: sl<AuthRepository>()));
  // sl.registerFactory(() => HomeBloc(homeRepository: sl<HomeRepository>()));
  // sl.registerFactory(() => ProfileBloc(profileRepository: sl<ProfileRepository>()));
  // sl.registerFactory(() => NotificationBloc(notificationRepository: sl<NotificationRepository>()));
  // sl.registerFactory(() => ThemeBloc(prefUtils: sl<PrefUtils>()));
  // sl.registerFactory(() => AuthBloc(authRepository: sl<AuthRepository>()));
  //
}
