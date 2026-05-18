import 'package:dio/dio.dart';
import '/features/menu/domain/entities/menu_item_entity.dart';
import '/features/menu/domain/repositories/i_menu_repository.dart';

class MenuRemoteRepositoryImpl implements IMenuRepository {
  final Dio _dio;

  final String _baseUrl = 'http://192.168.18.102:8080/xrest';

  MenuRemoteRepositoryImpl(this._dio);

  @override
  Future<List<MenuItemEntity>> getAvailableMenuItems() async {
    try {
      final response = await _dio.get('$_baseUrl/produtos');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<MenuItemEntity> allItems = _parseAndFlattenProducts(responseData);


        return allItems.where((item) => item.isAvailable).toList();
      } else {
        throw Exception('Failed to load menu items. Status Code: ${response.statusCode}');
      }
    } catch (e) {

      throw Exception('Network error occurred: $e');
    }
  }

  @override
  Future<List<MenuItemEntity>> getMenuItemsByCategory(int categoryId) async {

    try {
      final allAvailableItems = await getAvailableMenuItems();

      return allAvailableItems
          .where((item) => item.categoryId == categoryId)
          .toList();
    } catch (e) {
      throw Exception('Failed to filter items by category: $e');
    }
  }

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