/*
 * File: waiter_dashboard_event.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Operational events triggered by the Waiter.
 */

import 'package:equatable/equatable.dart';

sealed class WaiterDashboardEvent extends Equatable {
  const WaiterDashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Fetches the current state of the restaurant floor.
final class FetchFloorDashboardEvent extends WaiterDashboardEvent {}

/// Triggered when the waiter taps the [ ENTREGAR ] button for a specific item.
final class MarkItemAsDeliveredEvent extends WaiterDashboardEvent {
  final String orderId;
  final String itemId; // Assuming OrderItemEntity has an ID here

  const MarkItemAsDeliveredEvent({required this.orderId, required this.itemId});

  @override
  List<Object?> get props => [orderId, itemId];
}