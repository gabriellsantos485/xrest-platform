/*
 * File: menu_item_entity.dart
 * Author: Gabriel
 * Date: 2026-03-01
 * Description: Core domain entity representing a menu item, decoupled from DTOs or Frameworks.
 */

/// Represents a standardized product in the restaurant's catalog.
/// Immutable by design to enforce predictable state management across the app.
class MenuItemEntity {
  final int id;
  final String name;
  final double unitPrice;
  final String? description;
  final String? photoUrl;
  final bool isAvailable;
  final int categoryId;

  const MenuItemEntity({
    required this.id,
    required this.name,
    required this.unitPrice,
    this.description,
    this.photoUrl,
    required this.isAvailable,
    required this.categoryId,
  });
}