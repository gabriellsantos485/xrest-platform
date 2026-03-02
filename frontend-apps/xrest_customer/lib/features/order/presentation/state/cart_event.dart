/*
 * File: cart_event.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Defines the input events triggered by the UI to mutate the shopping cart.
 */

import 'package:equatable/equatable.dart';
import '../../domain/entities/order_item_entity.dart';

/// Base event class for the Cart feature.
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when a user taps the '+' button or 'Adicionar' in the UI.
final class AddCartItemEvent extends CartEvent {
  final OrderItemEntity item;

  const AddCartItemEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Triggered when a user taps the '-' button or removes an item.
final class RemoveCartItemEvent extends CartEvent {
  final OrderItemEntity item;

  const RemoveCartItemEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Triggered to completely empty the cart (e.g., after a successful checkout).
final class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}