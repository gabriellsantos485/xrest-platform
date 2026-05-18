import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mainBackground,
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.dashboardTitle,
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          // TODO: Implements GridView for cards and charts based on prototype
          Expanded(
            child: Center(
              child: Text(
                'Conteúdo do Dashboard em Construção...',
                style: TextStyle(fontSize: 24, color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}