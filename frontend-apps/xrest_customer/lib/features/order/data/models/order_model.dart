import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';

class OrderModel {
  static Map<String, dynamic> toJson(OrderEntity order) {
    return {
      'id': order.id,
      'tableId': order.tableId,
      'customerCpf': order.customerCpf,
      'isTakeaway': order.isTakeaway,
      'guestCount': order.guestCount,
      'status': order.status.name.toUpperCase(),
      'createdAt': order.createdAt.toIso8601String(),
      'grandTotal': order.grandTotal,
      // The crucial list of items structured for the backend
      'items': order.items.map((item) => _itemToJson(item)).toList(),
    };
  }

  static Map<String, dynamic> _itemToJson(OrderItemEntity item) {
    return {
      'menuItemId': item.menuItem.id,
      'quantity': item.quantity,
      'unitPrice': item.unitPrice,
      'discount': item.discount,
      'totalValue': item.totalValue,
      'observations': item.observations,
      'status': item.status.name.toUpperCase(),
    };
  }
}