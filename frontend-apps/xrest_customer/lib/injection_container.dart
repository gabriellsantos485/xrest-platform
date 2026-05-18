import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xrest_customer/features/auth/presentation/state/auth_bloc.dart';
import 'package:xrest_customer/features/splash/presentation/state/splash_bloc.dart';

import '/features/menu/presentation/state/menu_bloc.dart';
import '/features/menu/domain/repositories/i_menu_repository.dart';
import '/features/menu/data/repositories/menu_mock_repository_impl.dart';

import 'features/order/presentation/state/cart_bloc.dart';
import 'features/order/presentation/state/history/order_history_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(() => MenuBloc(repository: sl<IMenuRepository>()));

  sl.registerLazySingleton<IMenuRepository>(
        () => MenuRemoteRepositoryImpl(Dio()),
  );

  sl.registerLazySingleton(() => CartBloc());
  sl.registerLazySingleton(() => SplashBloc());
  sl.registerLazySingleton(() => AuthBloc());
  sl.registerFactory(() => OrderHistoryBloc());
}