/*
 * File: injection_container.dart
 * Author: Elite Flutter Agent
 * Date: 2026-05-01
 * Description: Setup for the Service Locator (get_it) handling Dependency Injection.
 */

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xrest_waiter/core/cache/pedido_cache_service.dart';

import 'core/cache/category_cache_service.dart';
import 'core/cache/cliente_cache_service.dart';
import 'core/cache/global_cache_manager.dart';
import 'core/cache/menu_cache_service.dart';
import 'core/cache/mesa_cache_service.dart';
import 'core/cache/pagamento_cache_service.dart';
import 'core/cache/staff_cache_service.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/do_login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core & External Frameworks
  sl.registerLazySingleton(() => Dio());

  // ==========================================
  // FEATURES: AUTHENTICATION
  // ==========================================

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => DoLoginUseCase(sl()));

  // BLoCs
  // We use Factory for BLoCs to ensure we get a fresh instance whenever a new screen requests it
  sl.registerFactory(() => AuthBloc(doLogin: sl()));

  sl.registerLazySingleton(() => MenuCacheService());
  sl.registerLazySingleton(() => CategoryCacheService());
  sl.registerLazySingleton(()=> StaffCacheService());
  sl.registerLazySingleton(() => ClienteCacheService());
  sl.registerLazySingleton(() => MesaCacheService());
  sl.registerLazySingleton(() => PagamentoCacheService());
  sl.registerLazySingleton(() => PedidoCacheService());
  sl.registerLazySingleton(() => GlobalCacheManager(dio: sl(), menuCache: sl(), categoryCache: sl()));

}