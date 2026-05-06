import 'package:dio/dio.dart';
import '../../features/configuration/data/models/categoria_model.dart';
import '../../features/configuration/domain/entities/categoria.dart';

class CategoryCacheService {
  final List<Categoria> _categories = [];

  List<Categoria> get categories => _categories;

  // Retorna os nomes únicos para o Dropdown
  List<String> get categoryNames => _categories.map((c) => c.nome).toList();

  Future<void> fetchCategoriesFromServer(Dio client) async {
    print('Iniciando busca de categorias no servidor...');
    try {
      final response = await client.get('http://192.168.18.102:8080/xrest/categorias/');

      if (response.statusCode == 200) {
        _categories.clear();

        // Agora tratamos a resposta como um Map<String, dynamic>
        final Map<String, dynamic> data = response.data;

        // Iteramos sobre cada entrada do mapa
        data.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            // Pegamos o primeiro item da lista para criar o nosso modelo
            final categoryJson = value.first as Map<String, dynamic>;
            _categories.add(CategoriaModel.fromJson(categoryJson));
          }
        });

        // Ordena alfabeticamente para o dropdown ficar organizado
        _categories.sort((a, b) => a.nome.compareTo(b.nome));

        print('Categorias sincronizadas: ${_categories.map((e) => e.nome).toList()}');
      } else {
        throw Exception('Erro do servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('\n[ERRO] Falha ao sincronizar categorias: $e');
      throw Exception('Falha ao sincronizar as categorias.');
    }
  }

  Future<bool> createCategory(Dio client, String categoryName) async {
    print('Enviando nova categoria para o servidor: $categoryName');
    try {
      final response = await client.post(
        'http://192.168.18.102:8080/xrest/categorias/',
        data: {
          'nome': categoryName
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchCategoriesFromServer(client);
        return true;
      } else {
        throw Exception('Falha ao salvar. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('\n[ERRO POST] Falha ao criar categoria: $e');
      return false;
    }
  }

  Future<bool> updateCategory(Dio client, int id, String newName) async {
    try {
      final response = await client.put('http://192.168.18.102:8080/xrest/categorias/$id', data: {'nome': newName});
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchCategoriesFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      print('\n[ERRO PUT CATEGORIA]: $e');
      return false;
    }
  }

  Future<bool> deleteCategory(Dio client, int id) async {
    try {
      final response = await client.delete('http://192.168.18.102:8080/xrest/categorias/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchCategoriesFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      print('\n[ERRO DELETE CATEGORIA]: $e');
      return false;
    }
  }
}