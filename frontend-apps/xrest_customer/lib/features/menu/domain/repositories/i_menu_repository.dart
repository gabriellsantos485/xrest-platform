/*
 * File: i_menu_repository.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Abstract contract defining menu data operations for Dependency Inversion.
 */

import '/features/menu/domain/entities/menu_item_entity.dart';

/// Defines the boundary between the Domain layer and the Data layer.
/// Ensures the business logic remains agnostic to whether data comes from an API, Local DB, or a Mock.
abstract class IMenuRepository {

  /// Fetches the complete catalog of available menu items.
  Future<List<MenuItemEntity>> getAvailableMenuItems();

  /// Fetches items filtered by their specific category.
  Future<List<MenuItemEntity>> getMenuItemsByCategory(int categoryId);
}