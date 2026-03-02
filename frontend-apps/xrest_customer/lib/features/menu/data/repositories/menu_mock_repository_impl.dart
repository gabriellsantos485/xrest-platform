/*
 * File: menu_mock_repository_impl.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: In-memory implementation of IMenuRepository for early UI development and testing.
 */

import '/features/menu/domain/entities/menu_item_entity.dart';
import '/features/menu/domain/repositories/i_menu_repository.dart';

/// Simulates network delays and returns hardcoded domain entities.
/// This allows the Presentation layer (UI/State Management) to be fully built and tested
/// before the actual REST API is deployed.
class MenuMockRepositoryImpl implements IMenuRepository {

  final List<MenuItemEntity> _mockedDatabase = [
    const MenuItemEntity(
      id: 1,
      name: 'Parmegiana de Carne',
      unitPrice: 21.98,
      description: 'Parmegiana de carne refogado em molho de tomate com fritas.',
      photoUrl: 'assets/images/parmegiana.png',
      isAvailable: true,
      categoryId: 1, // Pratos
    ),
    const MenuItemEntity(
      id: 2,
      name: 'Suco de Laranja Natural',
      unitPrice: 8.50,
      description: 'Suco de laranja 400ml sem açúcar.',
      photoUrl: 'assets/images/suco_laranja.png',
      isAvailable: true,
      categoryId: 2, // Bebidas
    ),
    const MenuItemEntity(
      id: 3,
      name: 'Pudim de Leite',
      unitPrice: 12.00,
      description: 'Fatia de pudim tradicional com calda de caramelo.',
      photoUrl: 'assets/images/pudim.png',
      isAvailable: true,
      categoryId: 3, // Sobremesas
    ),
  ];

  @override
  Future<List<MenuItemEntity>> getAvailableMenuItems() async {
    // Simulates network latency to ensure UI loading states (shimmers/spinners) behave correctly.
    await Future.delayed(const Duration(milliseconds: 800));

    return _mockedDatabase.where((item) => item.isAvailable).toList();
  }

  @override
  Future<List<MenuItemEntity>> getMenuItemsByCategory(int categoryId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockedDatabase
        .where((item) => item.categoryId == categoryId && item.isAvailable)
        .toList();
  }
}