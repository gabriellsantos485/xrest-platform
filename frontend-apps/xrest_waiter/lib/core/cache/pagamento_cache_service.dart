import 'package:dio/dio.dart';
import '../../features/configuration/data/models/pagamento_model.dart';

class PagamentoCacheService {
  List<PagamentoModel> _pagamentosList = [];
  List<PagamentoModel> get pagamentosList => _pagamentosList;

  // GET - Listar
  Future<void> fetchPagamentosFromServer(Dio client) async {
    try {
      final response = await client.get('http://localhost:8080/xrest/v1/formas-pagamento');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _pagamentosList = data.map((json) => PagamentoModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('[ERRO FETCH PAGAMENTOS]: $e');
      throw e;
    }
  }

  // POST - Cadastrar
  Future<bool> createPagamento(Dio client, PagamentoModel pagamento) async {
    try {
      final response = await client.post(
        'http://localhost:8080/xrest/v1/formas-pagamento',
        data: pagamento.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchPagamentosFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // PUT - Atualizar
  Future<bool> updatePagamento(Dio client, PagamentoModel pagamento) async {
    try {
      final response = await client.put(
        'http://localhost:8080/xrest/v1/formas-pagamento/${pagamento.id}',
        data: pagamento.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchPagamentosFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // DELETE - Excluir
  Future<bool> deletePagamento(Dio client, int id) async {
    try {
      final response = await client.delete('http://localhost:8080/xrest/v1/formas-pagamento/$id');
      if (response.statusCode == 200) {
        await fetchPagamentosFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}