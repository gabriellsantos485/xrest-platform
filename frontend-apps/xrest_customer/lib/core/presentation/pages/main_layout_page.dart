/*
 * File: main_layout_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Root scaffold acting as a persistent shell. Manages the BottomNavigationBar
 * and switches the active body view without obscuring the navigation controls.
 */

import 'package:flutter/material.dart';

// Import the feature pages
import '../../../features/menu/presentation/pages/menu_page.dart';
import '../../../features/auth/presentation/pages/auth_wrapper_page.dart';
import '../../../features/order/presentation/pages/order_history_page.dart';
// Note: You can add the Orders/History page here later for the third tab

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _currentIndex = 0;

  // Defines the screens mapped to the BottomNavigationBar indices.
  final List<Widget> _pages = [
    const MenuPage(),         // Index 0: Menu
    const AuthWrapperPage(),  // Index 1: Profile / Login / Register
    const OrderHistoryPage(), // Index 2: History/Receipts
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves the state of the pages (e.g., scroll position) when switching tabs
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF8C00),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu, size: 30), label: 'Cardápio'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 30), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined, size: 30), label: 'Pedidos'),
        ],
      ),
    );
  }
}