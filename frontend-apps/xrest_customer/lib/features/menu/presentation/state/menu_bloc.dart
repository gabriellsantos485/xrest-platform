/*
 * File: menu_bloc.dart
 * Author: Lua (Elite Flutter Agent)
 * Date: 2026-04-18
 * Description: BLoC updated to handle alphabetical sorting of categories and items.
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:collection'; // For SplayTreeMap if needed, but we'll use a simpler approach
import '../../domain/repositories/i_menu_repository.dart';
import '../../domain/entities/menu_item_entity.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IMenuRepository repository;

  MenuBloc({required this.repository}) : super(MenuInitial()) {
    on<FetchAvailableMenuEvent>(_onFetchMenu);
  }

  Future<void> _onFetchMenu(FetchAvailableMenuEvent event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final items = await repository.getAvailableMenuItems();

      // 1. Initial grouping
      final Map<String, List<MenuItemEntity>> groupedData = {};
      for (var item in items) {
        if (!groupedData.containsKey(item.categoryName)) {
          groupedData[item.categoryName] = [];
        }
        groupedData[item.categoryName]!.add(item);
      }

      // 2. Sorting Categories (Keys) alphabetically
      final sortedCategoryNames = groupedData.keys.toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      // 3. Creating a new sorted Map and sorting Items within each category
      final Map<String, List<MenuItemEntity>> sortedGroupedData = LinkedHashMap();

      for (var category in sortedCategoryNames) {
        final categoryItems = groupedData[category]!;

        // Sorting items alphabetically by name
        categoryItems.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

        sortedGroupedData[category] = categoryItems;
      }

      emit(MenuLoaded(groupedItems: sortedGroupedData));
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }
}