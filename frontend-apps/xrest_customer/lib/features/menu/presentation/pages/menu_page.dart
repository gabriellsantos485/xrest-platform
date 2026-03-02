/*
 * File: menu_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Main UI for the Digital Menu. Integrates with MenuBloc to render categories and best sellers.
 */

import 'package:flutter/material.dart';
import '../widgets/category_items_sheet.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real scenario, this would be wrapped in a BlocBuilder to react to MenuState.
    // We are building the static layout based on the provided mockups.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CARDÁPIO',
          style: TextStyle(
            color: Color(0xFFFF8C00), // Primary Orange
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildBestSellersSection(),
              const SizedBox(height: 24),
              _buildCategoryList(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFFC107), width: 1.5), // Yellow border
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Pesquisar...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildBestSellersSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFC107)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mais vendidos',
            style: TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildBestSellerItem('Coca-Cola', 'assets/images/coca.png'),
                _buildBestSellerItem('Marguerita', 'assets/images/marguerita.png'),
                _buildBestSellerItem('Feijoada', 'assets/images/feijoada.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellerItem(String name, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[200],
            // backgroundImage: AssetImage(imagePath), // Uncomment when assets exist
            child: const Icon(Icons.fastfood, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(color: Color(0xFFFF8C00), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    final categories = ['Acompanhamento', 'Bebida', 'Lanche'];

    return Column(
      children: categories.map((category) {
        return GestureDetector(
          onTap: () {
            // Opens the bottom sheet representing Image 2
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => CategoryItemsSheet(categoryName: category),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[800], // Fallback background
              // image: DecorationImage(image: AssetImage('...'), fit: BoxFit.cover),
            ),
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(16),
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFFF8C00),
      unselectedItemColor: const Color(0xFFFF8C00),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 30), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined, size: 30), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined, size: 30), label: ''),
      ],
    );
  }
}