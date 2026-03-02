/*
 * File: main.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Application entry point. Initializes dependencies and sets up global state providers.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        // The CartBloc is provided globally since the cart is accessible anywhere
        BlocProvider<CartBloc>(
          create: (_) => di.sl<CartBloc>(),
        ),
        // The MenuBloc is provided and immediately fetches the available menu
        BlocProvider<MenuBloc>(
          create: (_) => di.sl<MenuBloc>()..add(const FetchAvailableMenuEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'X-REST Customer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFFF8C00), // Primary Orange
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: const MenuPage(), // Our previously built Menu UI
      ),
    );
  }
}