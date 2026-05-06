/*
 * File: menu_item_entity.dart
 * Author: Lua (Elite Flutter Agent)
 * Date: 2026-04-18
 * Description: Pure domain entity representing a menu item, now including categoryName for dynamic grouping.
 */

import 'package:equatable/equatable.dart';

class MenuItemEntity extends Equatable {
  final int id;
  final String name;
  final double unitPrice;
  final String? description;
  final String photoUrl;
  final bool isAvailable;
  final int categoryId;
  final String categoryName; // ADDED: Required for dynamic UI grouping

  const MenuItemEntity({
    required this.id,
    required this.name,
    required this.unitPrice,
    this.description,
    required this.photoUrl,
    required this.isAvailable,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    unitPrice,
    description,
    photoUrl,
    isAvailable,
    categoryId,
    categoryName,
  ];
}