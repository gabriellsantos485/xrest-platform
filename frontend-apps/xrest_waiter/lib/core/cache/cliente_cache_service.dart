import 'package:dio/dio.dart';
import '../../features/configuration/data/models/cliente_model.dart';

class ClienteCacheService {
  List<ClienteModel> _clienteList = [];
  List<ClienteModel> get clienteList => _clienteList;

  // GET - Lista todos
  Future<void> fetchClientsFromServer(Dio client) async {
    try {
      final response = await client.get('http://localhost:8080/xrest/clientes');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _clienteList = data.map((json) => ClienteModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('[ERRO FETCH CLIENTES]: $e');
      throw e;
    }
  }

  // POST - Cadastrar
  Future<bool> createClient(Dio client, ClienteModel cliente) async {
    try {
      final response = await client.post(
        'http://localhost:8080/xrest/cliente/cadastrar',
        data: cliente.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchClientsFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // PUT - Atualizar
  Future<bool> updateClient(Dio client, ClienteModel cliente) async {
    try {
      final response = await client.put(
        'http://localhost:8080/xrest/cliente/atualizar/${cliente.id}',
        data: cliente.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchClientsFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // DELETE - Excluir
  Future<bool> deleteClient(Dio client, int id) async {
    try {
      final response = await client.delete('http://localhost:8080/xrest/cliente/delete/$id');
      if (response.statusCode == 200) {
        await fetchClientsFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}