/*
 * File: i_order_repository.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Abstract contract defining order submission and retrieval operations.
 */

import '../entities/order_entity.dart';

/// Contract bridging the Domain layer to Data sources for Order operations.
abstract class IOrderRepository {

  /// Submits the local cart (OrderEntity) to the backend to be processed by the kitchen.
  Future<OrderEntity> submitOrder(OrderEntity order);

  /// Fetches an active order by table number.
  Future<OrderEntity?> getActiveOrderByTable(int tableId);
}