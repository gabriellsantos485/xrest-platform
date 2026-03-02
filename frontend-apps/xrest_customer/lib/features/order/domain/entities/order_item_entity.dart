/*
 * File: order_item_entity.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Domain entity representing a single item within a shopping cart/order.
 * Encapsulates calculation logic and business rules (e.g., RN001).
 */

import '/features/menu/domain/entities/menu_item_entity.dart';

/// Defines the possible states of an order item based on the data dictionary.
enum OrderItemStatus { pending, preparing, ready, delivered, canceled }

class OrderItemEntity {
  final String? id; // Nullable because it might not have been sent to the DB yet
  final MenuItemEntity menuItem;
  int quantity;
  final double unitPrice;
  final double discount;
  String? observations;
  OrderItemStatus status;

  OrderItemEntity({
    this.id,
    required this.menuItem,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
    this.observations,
    this.status = OrderItemStatus.pending,
  });

  /// Calculates the total value for this specific item line.
  double get totalValue => (unitPrice * quantity) - discount;

  /// Business Rule RN001: An item cannot be altered or deleted if it's already being prepared or is ready.
  bool get canBeModified {
    return status == OrderItemStatus.pending || status == OrderItemStatus.canceled;
  }

  /// Mutator method to safely update quantity, respecting business rules.
  void updateQuantity(int newQuantity) {
    if (!canBeModified) {
      throw Exception('Business Rule Violation: Cannot modify an item in preparation.');
    }
    if (newQuantity < 0) return;
    quantity = newQuantity;
  }
}