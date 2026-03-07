/*
 * File: main.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Application entry point. Initializes dependencies and sets up global state providers.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xrest_customer/features/auth/presentation/state/auth_bloc.dart';

import 'features/order/presentation/state/history/order_history_bloc.dart';
import 'features/splash/presentation/page/splash_page.dart';
import 'features/splash/presentation/state/splash_bloc.dart';
import 'injection_container.dart' as di;
import 'features/menu/presentation/pages/menu_page.dart';
import 'features/order/presentation/state/cart_bloc.dart';
import 'features/menu/presentation/state/menu_bloc.dart';
import 'features/menu/presentation/state/menu_event.dart';

void main() async {
  // Ensures Flutter bindings are initialized before calling async code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Dependency Injection container
  await di.init();

  runApp(const XRestCustomerApp());
}

class XRestCustomerApp extends StatelessWidget {
  const XRestCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(create: (_) => di.sl<CartBloc>()),
        BlocProvider<MenuBloc>(create: (_) => di.sl<MenuBloc>()),
        BlocProvider<SplashBloc>(create: (_) => di.sl<SplashBloc>()),
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<OrderHistoryBloc>(create: (_) => di.sl<OrderHistoryBloc>()),
      ],
      child: MaterialApp(
        title: 'X-REST Customer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFFF8C00),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: const SplashPage(), // Initial route is now the Splash!
      ),
    );
  }
}