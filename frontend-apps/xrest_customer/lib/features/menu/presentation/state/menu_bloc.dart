/*
 * File: menu_bloc.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Orchestrates the business flow, transforming MenuEvents into discrete MenuStates.
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'menu_event.dart';
import 'menu_state.dart';
import '../../domain/repositories/i_menu_repository.dart';

/// Manages the state of the Menu feature.
/// Depends strictly on abstractions (IMenuRepository), adhering to the Dependency Inversion Principle.
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IMenuRepository _menuRepository;

  MenuBloc({required IMenuRepository menuRepository})
      : _menuRepository = menuRepository,
        super(const MenuInitial()) {
    on<FetchAvailableMenuEvent>(_onFetchAvailableMenu);
    on<FetchMenuByCategoryEvent>(_onFetchMenuByCategory);
  }

  /// Handles the request to fetch all available menu items.
  Future<void> _onFetchAvailableMenu(
      FetchAvailableMenuEvent event,
      Emitter<MenuState> emit,
      ) async {
    emit(const MenuLoading());
    try {
      final items = await _menuRepository.getAvailableMenuItems();

      if (items.isEmpty) {
        emit(const MenuError(message: 'Nenhum item disponível no momento.'));
        return;
      }

      emit(MenuLoaded(items: items));
    } catch (e) {
      // In a production environment, 'e' should be parsed into a specific Failure class.
      emit(const MenuError(message: 'Falha ao carregar o cardápio. Tente novamente mais tarde.'));
    }
  }

  /// Handles the request to fetch menu items filtered by category.
  Future<void> _onFetchMenuByCategory(
      FetchMenuByCategoryEvent event,
      Emitter<MenuState> emit,
      ) async {
    emit(const MenuLoading());
    try {
      final items = await _menuRepository.getMenuItemsByCategory(event.categoryId);
      emit(MenuLoaded(items: items));
    } catch (e) {
      emit(const MenuError(message: 'Falha ao carregar a categoria selecionada.'));
    }
  }
}