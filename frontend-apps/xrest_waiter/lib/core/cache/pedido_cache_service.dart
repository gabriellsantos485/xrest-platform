import 'package:dio/dio.dart';
import '../../features/orders/data/models/pedido_model.dart';

class PedidoCacheService {
  List<PedidoModel> _pedidosList = [];
  List<PedidoModel> get pedidosList => _pedidosList;

  Future<void> fetchPedidosByDate(Dio client, DateTime dataInicio, DateTime dataFim) async {
    try {
      // Formata INÍCIO
      String startYear = dataInicio.year.toString().padLeft(4, '0');
      String startMonth = dataInicio.month.toString().padLeft(2, '0');
      String startDay = dataInicio.day.toString().padLeft(2, '0');
      String inicioStr = '$startYear-$startMonth-${startDay}T00:00:00Z';

      // Formata FIM
      String endYear = dataFim.year.toString().padLeft(4, '0');
      String endMonth = dataFim.month.toString().padLeft(2, '0');
      String endDay = dataFim.day.toString().padLeft(2, '0');
      String fimStr = '$endYear-$endMonth-${endDay}T23:59:59Z';

      final url = 'http://localhost:8080/xrest/v1/pedidos/data?inicio=$inicioStr&fim=$fimStr';

      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _pedidosList = data.map((json) => PedidoModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('[ERRO FETCH PEDIDOS]: $e');
      throw e;
    }
  }
}