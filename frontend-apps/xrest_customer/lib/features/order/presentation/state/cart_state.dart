/*
 * File: cart_state.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Defines the states for the shopping cart. Ensures the UI reacts to changes in the OrderEntity.
 */

import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

/// Base state class for the Cart feature.
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the cart is completely empty.
final class CartInitial extends CartState {
  const CartInitial();
}

/// Represents an active cart with one or more items.
/// Carries the aggregated OrderEntity containing subtotals and item lists.
final class CartUpdated extends CartState {
  final OrderEntity order;

  // We use a timestamp to force Equatable to recognize state changes
  // even if the OrderEntity instance remains the same in memory.
  final int timestamp;

  CartUpdated({required this.order}) : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object?> get props => [order, timestamp];
}

/// Represents a business rule violation or system error (e.g., trying to remove an item in preparation).
final class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}