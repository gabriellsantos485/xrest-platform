/*
 * File: main.dart
 * Author: Lua (Elite Flutter Agent) & Equipa X-REST
 * Date: 2026-05-02
 * Description: Application entry point. Sets up global state management via MultiBlocProvider
 * ensuring all routes have access to core BLoCs (like AuthBloc).
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const XRestApp());
}

class XRestApp extends StatelessWidget {
  const XRestApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Elevating the BLoC provision to the root level allows any route pushed
    // via Navigator to safely read the global state (e.g., User Role).
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        // Additional global BLoCs (e.g., ThemeBloc, NotificationBloc) will be registered here.
      ],
      child: MaterialApp(
        title: 'X-REST Desktop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const LoginPage(),
      ),
    );
  }
}