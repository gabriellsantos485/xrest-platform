/*
 * File: order_entity.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Aggregate root entity representing the shopping cart or an active order.
 */

import 'order_item_entity.dart';

/// Defines the overall status of the Order.
enum OrderStatus { open, inProgress, closed, canceled }

class OrderEntity {
  final String? id;
  final List<OrderItemEntity> items;
  int? tableId;
  String? customerCpf;
  bool isTakeaway;
  int guestCount;
  OrderStatus status;
  final DateTime createdAt;

  OrderEntity({
    this.id,
    List<OrderItemEntity>? items,
    this.tableId,
    this.customerCpf,
    this.isTakeaway = false,
    this.guestCount = 1,
    this.status = OrderStatus.open,
    DateTime? createdAt,
  })  : items = items ?? [],
        createdAt = createdAt ?? DateTime.now();

  /// Calculates the grand total of the order by summing all item totals.
  double get grandTotal {
    return items.fold(0.0, (sum, item) => sum + item.totalValue);
  }

  /// Adds a new item to the cart or increments quantity if it already exists with the same observations.
  void addItem(OrderItemEntity newItem) {
    if (status != OrderStatus.open && status != OrderStatus.inProgress) {
      throw Exception('Business Rule RN004: Cannot alter a closed order.');
    }

    final existingItemIndex = items.indexWhere((i) =>
    i.menuItem.id == newItem.menuItem.id &&
        i.observations == newItem.observations
    );

    if (existingItemIndex != -1) {
      items[existingItemIndex].updateQuantity(items[existingItemIndex].quantity + newItem.quantity);
    } else {
      items.add(newItem);
    }
  }

  /// Removes an item from the cart, respecting Business Rule RN001.
  void removeItem(OrderItemEntity itemToRemove) {
    if (!itemToRemove.canBeModified) {
      throw Exception('Business Rule RN001: Cannot remove an item already sent to kitchen.');
    }
    items.remove(itemToRemove);
  }
}