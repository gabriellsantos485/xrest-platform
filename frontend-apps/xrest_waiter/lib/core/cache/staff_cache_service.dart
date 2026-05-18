import 'package:dio/dio.dart';
import '../../features/configuration/data/models/staff_model.dart';

class StaffCacheService {
  List<StaffModel> _staffList = [];
  List<StaffModel> get staffList => _staffList;

  Future<void> fetchStaffFromServer(Dio client) async {
    try {

      final response = await client.get('http://localhost:8080/xrest/funcionarios');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _staffList = data.map((json) => StaffModel.fromJson(json)).toList();
        print('Funcionários carregados: ${_staffList.length}');
      }
    } catch (e) {
      print('[ERRO FETCH STAFF]: $e');
      throw e;
    }
  }

  Future<bool> updateStaff(Dio client, StaffModel staff) async {
    try {
      final response = await client.put(
        'http://localhost:8080/xrest/funcionario/atualizar/${staff.id}',
        data: staff.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchStaffFromServer(client); // Recarrega a lista
        return true;
      }
      return false;
    } catch (e) {
      print('[ERRO UPDATE STAFF]: $e');
      return false;
    }
  }

  Future<bool> deleteStaff(Dio client, int id) async {
    try {
      final response = await client.delete('http://localhost:8080/xrest/funcionario/delete/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchStaffFromServer(client); // Recarrega a lista sem o funcionário deletado
        return true;
      }
      return false;
    } catch (e) {
      print('[ERRO DELETE STAFF]: $e');
      return false;
    }
  }
}