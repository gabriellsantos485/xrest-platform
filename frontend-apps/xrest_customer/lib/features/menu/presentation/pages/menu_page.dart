/*
 * File: menu_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Reactive Main UI for the Digital Menu. Integrates with MenuBloc and CartBloc.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xrest_customer/injection_container.dart';
import '../../../auth/presentation/pages/auth_wrapper_page.dart';
import '../../../order/presentation/pages/cart_summary_page.dart';
import '../../../order/presentation/state/cart_bloc.dart';
import '../../../order/presentation/state/cart_state.dart';
import '../state/menu_bloc.dart';
import '../state/menu_event.dart';
import '../state/menu_state.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../widgets/category_items_sheet.dart';

class MenuPage extends StatefulWidget{
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  @override
  void initState() {
    super.initState();
    // Architectural pattern: JIT Fetching.
    // We delay the BLoC event dispatch until the current frame finishes rendering.
    // This prevents "Looking up a deactivated widget's ancestor" exceptions.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuBloc>().add(const FetchAvailableMenuEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // ... (Existing AppBar implementation)
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CARDÁPIO',
          style: TextStyle(color: Color(0xFFFF8C00),
              fontWeight: FontWeight.bold,
              fontSize: 28),
        ),
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          // ... (Existing Body implementation with Loading, Error, and Success states)
          if (state is MenuLoading || state is MenuInitial) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF8C00)));
          }

          if (state is MenuError) {
            return Center(child: Text(state.message,
                style: const TextStyle(color: Colors.red, fontSize: 16)));
          }

          if (state is MenuLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    _buildBestSellersSection(),
                    const SizedBox(height: 24),

                    _buildCategoryList(context, state.groupedItems),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),


      // The contextual floating bag we built earlier
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated && state.order.items.isNotEmpty) {
            return FloatingActionButton.extended(
              backgroundColor: const Color(0xFF10B981),
              elevation: 4,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CartSummaryPage()),
                );
              },
              icon: const Icon(
                  Icons.shopping_bag_outlined, color: Colors.white),
              label: Text(
                '${state.order.items.length} itens - R\$ ${state.order
                    .grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }


  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFFC107), width: 1.5),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Pesquisar...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildBestSellersSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFC107)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mais vendidos', style: TextStyle(
              color: Color(0xFFFF8C00), fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildBestSellerItem('Coca-Cola'),
                _buildBestSellerItem('Marguerita'),
                _buildBestSellerItem('Feijoada'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellerItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.fastfood, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(color: Color(0xFFFF8C00), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, Map<String, List<MenuItemEntity>> groupedItems) {

    // Safety check if menu is completely empty
    if (groupedItems.isEmpty) {
      return const Center(child: Text('Nenhum item disponível.', style: TextStyle(color: Colors.grey)));
    }

    return Column(
      // Maps over the dynamic keys (Category Names) provided by the Spring Boot API
      children: groupedItems.entries.map((entry) {
        final categoryName = entry.key;
        final itemsInCategory = entry.value;

        return GestureDetector(
          onTap: () {
            // No need to filter here anymore! The BLoC already grouped them perfectly.
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => CategoryItemsSheet(
                categoryName: categoryName,
                items: itemsInCategory, // Passes the pre-filtered list directly
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[800], // Suggestion: Use Theme.of(context) instead of fixed colors
            ),
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(16),
            child: Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

}