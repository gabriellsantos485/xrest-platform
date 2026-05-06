/*
 * File: menu_event.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Defines the input events triggered by the UI to interact with the Menu feature.
 */

import 'package:equatable/equatable.dart';

/// Base event class for the Menu feature.
sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered to request the entire available catalog.
final class FetchAvailableMenuEvent extends MenuEvent {
  const FetchAvailableMenuEvent();
}

/// Triggered when the user filters the catalog by a specific category (e.g., 'Bebidas', 'Pratos').
final class FetchMenuByCategoryEvent extends MenuEvent {
  final int categoryId;

  const FetchMenuByCategoryEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

