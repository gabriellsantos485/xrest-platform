/*
 * File: menu_item_tile.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Stateful widget representing a single menu item with progressive +/- quantity controls.
 */

import 'package:flutter/material.dart';

class MenuItemTile extends StatefulWidget {
  const MenuItemTile({super.key});

  @override
  State<MenuItemTile> createState() => _MenuItemTileState();
}

class _MenuItemTileState extends State<MenuItemTile> {
  // Local state to handle UI rendering of +/- buttons.
  int _quantity = 0;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFC107)), // Yellow border
      ),
      child: Row(
        children: [
          // Product Image
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            // backgroundImage: AssetImage('...'), // Future implementation
          ),
          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Coca Cola 200 ML',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ovos, Leite, Massa, Açucar e Arroz Granjeiro',
                  style: TextStyle(color: Color(0xFFFF8C00), fontSize: 11),
                ),
                const SizedBox(height: 8),
                Text(
                  'Porções para 2 pessoas',
                  style: TextStyle(color: Colors.orange[300], fontSize: 11),
                ),
              ],
            ),
          ),

          // Progressive Quantity Controls
          _buildQuantityControls(),
        ],
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Conditional Rendering: Only show minus button and text if quantity > 0
        if (_quantity > 0) ...[
          GestureDetector(
            onTap: _decrement,
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.remove, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$_quantity',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 12),
        ],

        // Plus button is always visible
        GestureDetector(
          onTap: _increment,
          child: const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF10B981), // Green Color
            child: Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}