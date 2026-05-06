/*
 * File: menu_state.dart
 * Author: Lua (Elite Flutter Agent)
 * Date: 2026-04-18
 * Description: Defines the states for the Menu feature.
 */

import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_item_entity.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  // The UI will use this map to dynamically build categories
  final Map<String, List<MenuItemEntity>> groupedItems;

  const MenuLoaded({required this.groupedItems});

  @override
  List<Object?> get props => [groupedItems];
}

class MenuError extends MenuState {
  final String message;

  const MenuError({required this.message});

  @override
  List<Object?> get props => [message];
}