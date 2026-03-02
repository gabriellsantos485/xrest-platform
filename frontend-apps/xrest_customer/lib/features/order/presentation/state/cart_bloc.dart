/*
 * File: cart_bloc.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Orchestrates cart operations. Intercepts business rule exceptions and manages the OrderEntity lifecycle.
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../domain/entities/order_entity.dart';

/// Manages the state of the customer's current order/cart.
class CartBloc extends Bloc<CartEvent, CartState> {
  // Holds the single source of truth for the current active order session.
  OrderEntity _currentOrder;

  CartBloc()
      : _currentOrder = OrderEntity(),
        super(const CartInitial()) {
    on<AddCartItemEvent>(_onAddCartItem);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<ClearCartEvent>(_onClearCart);
  }

  /// Handles adding items to the cart.
  /// Delegates the business logic to the OrderEntity aggregate root.
  void _onAddCartItem(AddCartItemEvent event, Emitter<CartState> emit) {
    try {
      _currentOrder.addItem(event.item);
      emit(CartUpdated(order: _currentOrder));
    } catch (e) {
      // Catches Business Rule exceptions (e.g., RN004 - Cannot alter closed order)
      emit(CartError(message: e.toString()));
      // Restore previous valid state so the UI doesn't stay stuck on the error screen.
      emit(CartUpdated(order: _currentOrder));
    }
  }

  /// Handles removing items or decrementing quantities.
  void _onRemoveCartItem(RemoveCartItemEvent event, Emitter<CartState> emit) {
    try {
      _currentOrder.removeItem(event.item);

      if (_currentOrder.items.isEmpty) {
        emit(const CartInitial());
      } else {
        emit(CartUpdated(order: _currentOrder));
      }
    } catch (e) {
      // Catches Business Rule exceptions (e.g., RN001 - Cannot delete item in preparation)
      emit(CartError(message: e.toString()));
      emit(CartUpdated(order: _currentOrder));
    }
  }

  /// Clears the active session completely and resets the OrderEntity.
  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    _currentOrder = OrderEntity();
    emit(const CartInitial());
  }
}