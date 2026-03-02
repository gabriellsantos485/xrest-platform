/*
 * File: category_items_sheet.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Bottom sheet displaying items of a specific category with add-to-cart functionality.
 */

import 'package:flutter/material.dart';
import 'menu_item_tile.dart';

class CategoryItemsSheet extends StatelessWidget {
  final String categoryName;

  const CategoryItemsSheet({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // Takes 85% of screen height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Header Image matching the tapped category
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              color: Colors.grey, // Placeholder for category image
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.topLeft,
            child: Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Scrollable List of Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4, // Mocked item count
              itemBuilder: (context, index) {
                return const MenuItemTile();
              },
            ),
          ),

          // Confirmation Button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981), // Green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close sheet and theoretically add to cart
                },
                child: const Text(
                  'Adicionar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}