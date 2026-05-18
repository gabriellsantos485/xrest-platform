import '../../features/configuration/data/models/menu_item_model.dart';
import '../../features/configuration/domain/entities/menu_item.dart';
import 'package:dio/dio.dart';

class MenuCacheService {
  final Map<String, List<MenuItem>> _itemsByCategory = {};

  // Método chamado logo após o Login ser bem-sucedido
  // Método chamado logo após o Login ser bem-sucedido
  void parseAndPopulate(Map<String, dynamic> jsonResponse) {
    _itemsByCategory.clear();

    try {
      jsonResponse.forEach((categoriaChave, listaDeItens) {
        if (listaDeItens is List) {
          _itemsByCategory[categoriaChave] = listaDeItens
              .map((itemJson) => MenuItemModel.fromJson(itemJson as Map<String, dynamic>))
              .toList();
        }
      });

      // ==========================================
      // DEBUG: IMPRESSÃO DO ESTADO DO CACHE
      // ==========================================
      print('\n=== DEBUG: CACHE DO CARDÁPIO POPULADO ===');
      print('Total de Categorias Encontradas: ${_itemsByCategory.length}');

      final todosOsItens = _itemsByCategory.values.expand((lista) => lista).toList();
      print('Total de Itens Carregados: ${todosOsItens.length}\n');

      for (var item in todosOsItens) {
        print('-> ID: ${item.id.toString().padLeft(3, '0')} | Nome: "${item.nome}" | Categoria: ${item.categoriaNome}');
      }
      print('=========================================\n');

    } catch (e, stacktrace) {
      // Se houver um erro de tipagem no fromJson, ele será pego aqui
      print('\n[ERRO CRÍTICO] Falha ao processar o JSON do Cardápio:');
      print(e.toString());
      print(stacktrace);
    }
  }

  List<MenuItem> searchItems(String query) {
    if (query.trim().isEmpty) return [];

    final normalizedQuery = query.toLowerCase().trim();
    final allItems = _itemsByCategory.values.expand((lista) => lista).toList();

    return allItems.where((item) {
      final matchesName = item.nome.toLowerCase().contains(normalizedQuery);
      // Converte o ID (int) para string para permitir pesquisa pelo código
      final matchesId = item.id.toString().contains(normalizedQuery);
      return matchesName || matchesId;
    }).toList();
  }

  // Novo método para buscar os dados na API e enviá-los para o parser
  Future<void> fetchMenuFromServer(Dio client) async {
    print('Iniciando busca do cardápio no servidor...');
    try {
      final response = await client.get('http://192.168.18.102:8080/xrest/produtos');

      if (response.statusCode == 200) {
        parseAndPopulate(response.data as Map<String, dynamic>);
      } else {
        // Se a API responder, mas com erro (ex: 500 Internal Server Error)
        throw Exception('Erro do servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('\n[ERRO DE CONEXÃO] Não foi possível baixar o cardápio:');
      print(e.toString());

      // A MÁGICA ESTÁ AQUI: Nós rebolamos o erro para cima,
      // para que o GlobalCacheManager saiba que a missão falhou!
      throw Exception('Falha ao sincronizar o cardápio.');
    }
  }

  Future<void> saveProduct(Dio client, MenuItemModel product) async {
    try {
      Response response;
      final payload = product.toJson();

      if (product.id == 0) {
        // ID 0 = CREATE (POST)
        print('Iniciando POST para novo produto...');
        response = await client.post(
          'http://localhost:8080/xrest/produtos',
          data: payload,
        );
      } else {
        // ID > 0 = UPDATE (PUT) passando o ID na URL
        print('Iniciando PUT para atualizar produto ID ${product.id}...');
        response = await client.put(
          'http://localhost:8080/xrest/produtos/${product.id}',
          data: payload,
        );
      }

      // 200 (OK), 201 (Created) ou 204 (No Content)
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        // Se a operação foi um sucesso, sincronizamos o cache com o banco
        await fetchMenuFromServer(client);
      }
    } on DioException catch (e) {
      throw e; // Repassa o erro (ex: 409) para o Popup do formulário lidar
    } catch (e) {
      throw Exception('Erro ao processar a requisição.');
    }
  }

  // --- ADICIONE ESTE MÉTODO ---
  Future<void> deleteProduct(Dio client, int id) async {
    try {
      print('Iniciando SOFT DELETE (Inativar) para o produto ID: $id...');
      // O backend espera um PUT na rota específica de delete
      final response = await client.delete(
        'http://192.168.18.102:8080/xrest/produtos/$id',
        data: {}, // Corpo vazio, pois o backend fará a alteração automaticamente
      );

      // 200 (OK) ou 204 (No Content)
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchMenuFromServer(client); // Recarrega o cache para refletir o status Inativo
      }
    } on DioException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('Erro ao processar a exclusão.');
    }
  }


}