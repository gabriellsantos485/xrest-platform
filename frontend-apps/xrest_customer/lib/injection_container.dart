/*
 * File: injection_container.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Service Locator configuration using get_it. Wires up all layers of the Clean Architecture.
 */

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xrest_customer/features/auth/presentation/state/auth_bloc.dart';
import 'package:xrest_customer/features/splash/presentation/state/splash_bloc.dart';

// Imports - Menu Feature
import '/features/menu/presentation/state/menu_bloc.dart';
import '/features/menu/domain/repositories/i_menu_repository.dart';
import '/features/menu/data/repositories/menu_mock_repository_impl.dart';

// Imports - Order (Cart) Feature
import 'features/order/presentation/state/cart_bloc.dart';
import 'features/order/presentation/state/history/order_history_bloc.dart';

/// Global variable for the Service Locator
final sl = GetIt.instance;

/// Initializes and registers all dependencies.
/// Must be called in main.dart before runApp().
Future<void> init() async {

  // ===========================================================================
  // Feature: Menu
  // ===========================================================================

  // Bloc
  // Registered as a Factory because we usually want a fresh instance
  // every time the user accesses the Menu page.
  sl.registerFactory(() => MenuBloc(repository: sl<IMenuRepository>()));

  // Repository
  // Registered as a LazySingleton to save memory; it's only instantiated
  // the first time sl<IMenuRepository>() is called.
  sl.registerLazySingleton<IMenuRepository>(
        () => MenuRemoteRepositoryImpl(Dio()),
  );

  // ===========================================================================
  // Feature: Order / Cart
  // ===========================================================================

  // Bloc
  // Registered as a LazySingleton. This is CRITICAL. The shopping cart
  // must be a global, persisted state across the entire user session.
  sl.registerLazySingleton(() => CartBloc());
  sl.registerLazySingleton(() => SplashBloc());
  sl.registerLazySingleton(() => AuthBloc());
  sl.registerFactory(() => OrderHistoryBloc());

  // Note: IOrderRepository will be registered here once we build the
  // backend integration to submit the final order.
}