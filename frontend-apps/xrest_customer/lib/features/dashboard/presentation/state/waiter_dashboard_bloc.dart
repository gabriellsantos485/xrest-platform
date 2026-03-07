/*
 * File: waiter_dashboard_bloc.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Orchestrates the waiter's view of the restaurant floor.
 * Handles real-time (or mocked) updates for kitchen deliveries.
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'waiter_dashboard_event.dart';
import 'waiter_dashboard_state.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../order/domain/entities/order_item_entity.dart';

class WaiterDashboardBloc extends Bloc<WaiterDashboardEvent, WaiterDashboardState> {
  // In a real scenario, this is managed by IWaiterRepository
  List<OrderEntity> _mockedActiveOrders = [];

  WaiterDashboardBloc() : super(const WaiterDashboardInitial()) {
    on<FetchFloorDashboardEvent>(_onFetchFloorDashboard);
    on<MarkItemAsDeliveredEvent>(_onMarkItemAsDelivered);
  }

  Future<void> _onFetchFloorDashboard(
      FetchFloorDashboardEvent event,
      Emitter<WaiterDashboardState> emit,
      ) async {
    emit(const WaiterDashboardLoading());
    await Future.delayed(const Duration(milliseconds: 800));

    // MOCK: Creating a table that needs attention (item is ready)
    // Note: Adjust the entity constructors based on your shared domain definitions.
    // This assumes OrderEntity has a customerName field added for the Waiter context.

    emit(WaiterDashboardLoaded(
      attentionOrders: _mockedActiveOrders.where(_hasReadyItems).toList(),
      activeOrders: _mockedActiveOrders,
    ));
  }

  Future<void> _onMarkItemAsDelivered(
      MarkItemAsDeliveredEvent event,
      Emitter<WaiterDashboardState> emit,
      ) async {
    // 1. Find the order and the item
    // 2. Change the item status to OrderItemStatus.delivered
    // 3. Re-emit the WaiterDashboardLoaded state
    // TODO: Connect this to the Java Spring Boot Backend to persist the delivery.
  }

  /// Helper to check if an order has items waiting to be picked up from the kitchen.
  bool _hasReadyItems(OrderEntity order) {
    return order.items.any((item) => item.status == OrderItemStatus.ready);
  }
}