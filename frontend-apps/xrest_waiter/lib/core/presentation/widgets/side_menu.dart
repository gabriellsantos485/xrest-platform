/*
 * File: side_menu.dart
 * Author: Lua
 * Date: 2026-05-01
 * Description: Side menu with Role-Based Access Control (RBAC).
 * Hides restricted items from non-admin users.
 */

import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_colors.dart';

class SideMenuItem {
  final int index;
  final IconData icon;
  final String title;
  final bool adminOnly;

  SideMenuItem(this.index, this.icon, this.title, {this.adminOnly = false});
}

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final String userRole; // Role passed from Auth state
  final Function(int) onItemSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.userRole,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Definition of menu items with access restrictions
    final allItems = [
      SideMenuItem(0, Icons.home, AppStrings.menuHome, adminOnly: true),
      SideMenuItem(1, Icons.assignment, AppStrings.menuOrders),
      SideMenuItem(2, Icons.restaurant_menu, AppStrings.menuPrepQueue),
      SideMenuItem(3, Icons.dashboard, AppStrings.menuDashboards, adminOnly: true),
      SideMenuItem(4, Icons.settings, AppStrings.menuSettings, adminOnly: true),
    ];

    // Filters items based on user role
    final visibleItems = allItems.where((item) {
      if (userRole == 'ADMIN') return true;
      return !item.adminOnly;
    }).toList();

    return Container(
      width: 250,
      color: AppColors.menuBackground,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 48),
            child: Text(
              AppStrings.appName,
              style: TextStyle(color: AppColors.primaryOrange, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),

          // Render only allowed items
          ...visibleItems.map((item) => Column(
            children: [
              _buildMenuItem(item.index, item.icon, item.title),
              const SizedBox(height: 16),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String title) {
    final isActive = selectedIndex == index;
    return InkWell(
      onTap: () => onItemSelected(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.activeMenuIndicator : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textDark, size: 24),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}