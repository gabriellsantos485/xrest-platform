/*
 * File: category_items_sheet.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Bottom sheet displaying dynamically filtered items from the domain entity.
 */

import 'package:flutter/material.dart';
import '../../domain/entities/menu_item_entity.dart';
import 'menu_item_tile.dart';

class CategoryItemsSheet extends StatelessWidget {
  final String categoryName;
  final List<MenuItemEntity> items;

  const CategoryItemsSheet({super.key, required this.categoryName, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              color: Colors.grey,
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.topLeft,
            child: Text(
              categoryName,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Nenhum item disponível nesta categoria.'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return MenuItemTile(item: items[index]);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Concluir Seleção', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}