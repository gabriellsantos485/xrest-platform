/*
 * File: order_model.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-04
 * Description: Data Transfer Object (DTO) responsible for serializing the OrderEntity
 * into a JSON structure ready to be sent to the Spring Boot backend.
 */

import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';

class OrderModel {
  /// Transforms the aggregate root (OrderEntity) into a JSON payload.
  static Map<String, dynamic> toJson(OrderEntity order) {
    return {
      'id': order.id,
      'tableId': order.tableId,
      'customerCpf': order.customerCpf,
      'isTakeaway': order.isTakeaway,
      'guestCount': order.guestCount,
      'status': order.status.name.toUpperCase(), // e.g., 'OPEN'
      'createdAt': order.createdAt.toIso8601String(),
      'grandTotal': order.grandTotal,
      // The crucial list of items structured for the backend
      'items': order.items.map((item) => _itemToJson(item)).toList(),
    };
  }

  /// Transforms individual order items into JSON objects.
  static Map<String, dynamic> _itemToJson(OrderItemEntity item) {
    return {
      'menuItemId': item.menuItem.id, // Only sending the ID, not the whole product
      'quantity': item.quantity,
      'unitPrice': item.unitPrice,
      'discount': item.discount,
      'totalValue': item.totalValue,
      'observations': item.observations,
      'status': item.status.name.toUpperCase(),
    };
  }
}