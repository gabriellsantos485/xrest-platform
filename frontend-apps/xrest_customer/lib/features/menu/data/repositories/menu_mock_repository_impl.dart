/*
 * File: menu_remote_repository_impl.dart
 * Author: Lua (Elite Software Architect Agent)
 * Date: 2026-04-18
 * Description: Remote implementation of IMenuRepository consuming the Spring Boot REST API.
 */

import 'package:dio/dio.dart';
import '/features/menu/domain/entities/menu_item_entity.dart';
import '/features/menu/domain/repositories/i_menu_repository.dart';

class MenuRemoteRepositoryImpl implements IMenuRepository {
  final Dio _dio;

  // Base URL. Remember to use 10.0.2.2 if testing on Android Emulator,
  // or your machine's local IP if testing on a physical device.
  final String _baseUrl = 'http://192.168.18.102:8080/xrest';

  MenuRemoteRepositoryImpl(this._dio);

  @override
  Future<List<MenuItemEntity>> getAvailableMenuItems() async {
    try {
      final response = await _dio.get('$_baseUrl/products/');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<MenuItemEntity> allItems = _parseAndFlattenProducts(responseData);

        // Returns only the available items based on the backend status
        return allItems.where((item) => item.isAvailable).toList();
      } else {
        throw Exception('Failed to load menu items. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // In a production environment, map this to a custom Failure/Exception class
      throw Exception('Network error occurred: $e');
    }
  }

  @override
  Future<List<MenuItemEntity>> getMenuItemsByCategory(int categoryId) async {
    // Since the current endpoint returns all categorized products, we fetch all
    // and filter in-memory. For scalability, consider adding a specific endpoint
    // like /products/category/{id} in the Spring Boot backend later.
    try {
      final allAvailableItems = await getAvailableMenuItems();

      return allAvailableItems
          .where((item) => item.categoryId == categoryId)
          .toList();
    } catch (e) {
      throw Exception('Failed to filter items by category: $e');
    }
  }

  /// Helper method to transform the Map<String, List> from the API
  /// into a flat List<MenuItemEntity> required by the Domain layer.
  List<MenuItemEntity> _parseAndFlattenProducts(Map<String, dynamic> responseData) {
    final List<MenuItemEntity> parsedItems = [];

    responseData.forEach((categoryName, productsList) {
      final List<dynamic> productsJson = productsList as List<dynamic>;

      for (var json in productsJson) {
        final rawPhotoUrl = json['foto'] as String?;

        parsedItems.add(
          MenuItemEntity(
            id: json['id'] as int,
            name: json['nome'] as String,
            unitPrice: (json['valorUnidade'] as num).toDouble(),
            description: json['descricao'] as String?,
            // Defensive programming step
            photoUrl: _sanitizePhotoUrl(rawPhotoUrl),
            isAvailable: json['status'] == 'ATIVO',
            categoryId: json['categoria']['id'] as int,
            categoryName: json['categoria']['nome']
          ),
        );
      }
    });

    return parsedItems;
  }

  /// Sanitizes malformed strings injected by backend reflection/serialization errors
  String _sanitizePhotoUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return '';

    // Checks if the string contains a Java code snippet leak
    if (rawUrl.contains("private String foto = '")) {
      final startIndex = rawUrl.indexOf("'") + 1;
      final endIndex = rawUrl.lastIndexOf("'");
      if (startIndex > 0 && endIndex > startIndex) {
        return rawUrl.substring(startIndex, endIndex);
      }
    }
    return rawUrl;
  }
}