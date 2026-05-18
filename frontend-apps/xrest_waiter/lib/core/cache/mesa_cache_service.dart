import 'package:dio/dio.dart';
import '../../features/configuration/data/models/mesa_model.dart';

class MesaCacheService {
  List<MesaModel> _mesasList = [];
  List<MesaModel> get mesasList => _mesasList;

  // GET - Listar todas as mesas
  Future<void> fetchMesasFromServer(Dio client) async {
    try {
      final response = await client.get('http://localhost:8080/xrest/v1/mesas');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _mesasList = data.map((json) => MesaModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('[ERRO FETCH MESAS]: $e');
      throw e;
    }
  }

  // POST - Cadastrar
  Future<bool> createMesa(Dio client, MesaModel mesa) async {
    try {
      final response = await client.post(
        'http://localhost:8080/xrest/v1/mesas',
        data: mesa.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchMesasFromServer(client); // Atualiza a lista após sucesso
        return true;
      }
      return false;
    } catch (e) {
      print('[ERRO CREATE MESA]: $e');
      return false;
    }
  }

  // PUT - Atualizar
  Future<bool> updateMesa(Dio client, MesaModel mesa) async {
    try {
      final response = await client.put(
        'http://localhost:8080/xrest/mesa/atualizar/${mesa.id}',
        data: mesa.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchMesasFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      print('[ERRO UPDATE MESA]: $e');
      return false;
    }
  }

  // DELETE - Excluir
  Future<bool> deleteMesa(Dio client, int id) async {
    try {
      final response = await client.delete('http://localhost:8080/xrest/mesa/delete/$id');
      if (response.statusCode == 200) {
        await fetchMesasFromServer(client);
        return true;
      }
      return false;
    } catch (e) {
      print('[ERRO DELETE MESA]: $e');
      return false;
    }
  }
}