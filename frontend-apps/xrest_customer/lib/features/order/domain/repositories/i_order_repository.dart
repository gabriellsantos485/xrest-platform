import '../entities/order_entity.dart';

abstract class IOrderRepository {

  Future<OrderEntity> submitOrder(OrderEntity order);

  Future<OrderEntity?> getActiveOrderByTable(int tableId);
}