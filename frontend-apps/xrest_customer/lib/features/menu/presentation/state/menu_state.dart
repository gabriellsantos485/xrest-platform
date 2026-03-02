/*
 * File: menu_state.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Defines the discrete UI states for the Menu feature. Ensures predictable rendering.
 */

import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_item_entity.dart';

/// Base state class for the Menu feature.
/// Sealed to ensure exhaustive pattern matching in the UI layer (Dart 3+).
sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any interaction or data fetching occurs.
final class MenuInitial extends MenuState {
  const MenuInitial();
}

/// Indicates an ongoing asynchronous operation.
/// UI should react by displaying a shimmer effect or loading spinner.
final class MenuLoading extends MenuState {
  const MenuLoading();
}

/// Represents a successful data retrieval.
/// Carries the immutable list of menu items to be rendered by the UI.
final class MenuLoaded extends MenuState {
  final List<MenuItemEntity> items;

  const MenuLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

/// Represents a failure during data retrieval.
/// Carries an error message for user feedback or logging.
final class MenuError extends MenuState {
  final String message;

  const MenuError({required this.message});

  @override
  List<Object?> get props => [message];
}