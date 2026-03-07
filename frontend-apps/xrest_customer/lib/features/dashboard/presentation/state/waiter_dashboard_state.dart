/*
 * File: waiter_dashboard_state.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: States for the Waiter's Dashboard. Categorizes orders into
 * actionable (needs attention) and generally active tables.
 */

import 'package:equatable/equatable.dart';
// Note: Assuming OrderEntity is available via a shared core package or duplicated domain.
import '../../../order/domain/entities/order_entity.dart';
import '../../../order/domain/entities/order_entity.dart';

sealed class WaiterDashboardState extends Equatable {
  const WaiterDashboardState();

  @override
  List<Object?> get props => [];
}

final class WaiterDashboardInitial extends WaiterDashboardState {
  const WaiterDashboardInitial();
}

final class WaiterDashboardLoading extends WaiterDashboardState {
  const WaiterDashboardLoading();
}

final class WaiterDashboardLoaded extends WaiterDashboardState {
  final List<OrderEntity> attentionOrders; // Tables with items READY in the kitchen
  final List<OrderEntity> activeOrders;    // All open tables

  const WaiterDashboardLoaded({
    required this.attentionOrders,
    required this.activeOrders,
  });

  @override
  List<Object?> get props => [attentionOrders, activeOrders];
}

final class WaiterDashboardError extends WaiterDashboardState {
  final String message;

  const WaiterDashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}