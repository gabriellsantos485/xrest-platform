/*
 * File: order_history_state.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: States for the Order History feature. Separates active from past orders.
 */

import 'package:equatable/equatable.dart';
import '../../../domain/entities/order_entity.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => [];
}

final class OrderHistoryInitial extends OrderHistoryState {
  const OrderHistoryInitial();
}

final class OrderHistoryLoading extends OrderHistoryState {
  const OrderHistoryLoading();
}

final class OrderHistoryLoaded extends OrderHistoryState {
  final List<OrderEntity> activeOrders; // "Em andamento"
  final List<OrderEntity> pastOrders;   // "Concluídos" / "Cancelados"

  const OrderHistoryLoaded({
    required this.activeOrders,
    required this.pastOrders,
  });

  @override
  List<Object?> get props => [activeOrders, pastOrders];
}

final class OrderHistoryError extends OrderHistoryState {
  final String message;

  const OrderHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}