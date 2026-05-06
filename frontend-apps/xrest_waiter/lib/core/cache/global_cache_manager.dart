import 'package:dio/dio.dart';
import '../../injection_container.dart';
import 'category_cache_service.dart';
import 'menu_cache_service.dart';

class GlobalCacheManager {
  final Dio dio;
  final MenuCacheService menuCache;
  final CategoryCacheService categoryCache;

  GlobalCacheManager({required this.dio, required this.menuCache, required this.categoryCache,});

  /// Executa todas as requisições em paralelo e retorna true se tudo correr bem.
  Future<bool> initializeAppData() async {
    print('--- INICIANDO SINCRONIZAÇÃO GLOBAL ---');
    try {
      // Lista de todas as tarefas de sincronização
      await Future.wait([
        menuCache.fetchMenuFromServer(dio),
        categoryCache.fetchCategoriesFromServer(dio),

        Future.delayed(const Duration(milliseconds: 800)),
      ]);

      print('--- SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO ---');
      return true;
    } catch (e) {
      print('--- ERRO NA SINCRONIZAÇÃO: $e ---');
      return false;
    }
  }
}