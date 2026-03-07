/*
 * File: order_history_bloc.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Orchestrates the fetching and separation of order history into active and past categories.
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_history_state.dart';
import '../../../domain/entities/order_entity.dart';
// Note: In production, import the IOrderRepository here.

class FetchOrderHistoryEvent {}

class OrderHistoryBloc extends Bloc<FetchOrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc() : super(const OrderHistoryInitial()) {
    on<FetchOrderHistoryEvent>(_onFetchOrderHistory);
  }

  Future<void> _onFetchOrderHistory(
      FetchOrderHistoryEvent event,
      Emitter<OrderHistoryState> emit,
      ) async {
    emit(const OrderHistoryLoading());

    // Simulating network delay
    await Future.delayed(const Duration(seconds: 1));

    // MOCK DATA: Simulating orders from the backend
    final mockActive = [
      OrderEntity(id: '10042', status: OrderStatus.inProgress, isTakeaway: false, tableId: 5),
    ];

    final mockPast = [
      OrderEntity(id: '09981', status: OrderStatus.closed, isTakeaway: true, createdAt: DateTime.now().subtract(const Duration(days: 2))),
      OrderEntity(id: '09850', status: OrderStatus.canceled, isTakeaway: false, tableId: 12, createdAt: DateTime.now().subtract(const Duration(days: 5))),
    ];

    emit(OrderHistoryLoaded(activeOrders: mockActive, pastOrders: mockPast));
  }
}