/*
 * File: main_shell_page.dart
 * Author: Lua
 * Description: Shell with Role-based redirection and view filtering.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xrest_waiter/features/orders/presentation/pages/pedidos_page.dart';
import '../widgets/side_menu.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/configuration/presentation/pages/configuration_page.dart';
import '../../theme/app_colors.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  late int _selectedIndex;
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String userRole = 'USER';

    if (authState is AuthSuccess) {
      userRole = authState.user.role;
    }

    // Initialize index based on role: Admin starts at Home(0), others at Orders(1)
    if (!_isInitialized) {
      _selectedIndex = (userRole == 'ADMIN') ? 0 : 1;
      _isInitialized = true;
    }

    // Map index to Page Widget
    final List<Widget> _pages = [
      const DashboardPage(),                      // 0
      const PedidosPage() ,      // 1
      const Center(child: Text('Fila')),          // 2
      const Center(child: Text('Dashboards')),    // 3
      const ConfigurationPage(),                  // 4
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderYellow, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              SideMenu(
                selectedIndex: _selectedIndex,
                userRole: userRole,
                onItemSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: AppColors.borderYellow, width: 1.5)),
                  ),
                  child: _pages[_selectedIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}