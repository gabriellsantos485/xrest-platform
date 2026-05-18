import 'order_item_entity.dart';

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

  double get grandTotal {
    return items.fold(0.0, (sum, item) => sum + item.totalValue);
  }

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

  void removeItem(OrderItemEntity itemToRemove) {
    if (!itemToRemove.canBeModified) {
      throw Exception('Business Rule RN001: Cannot remove an item already sent to kitchen.');
    }
    items.remove(itemToRemove);
  }
}