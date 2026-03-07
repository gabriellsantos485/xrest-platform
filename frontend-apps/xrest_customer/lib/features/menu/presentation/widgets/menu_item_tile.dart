/*
 * File: menu_item_tile.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-01
 * Description: Reactive widget representing a single menu item. Listens to CartBloc to reflect accurate quantities.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../../order/domain/entities/order_item_entity.dart';
import '../../../order/presentation/state/cart_bloc.dart';
import '../../../order/presentation/state/cart_event.dart';
import '../../../order/presentation/state/cart_state.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItemEntity item;

  const MenuItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFC107)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            // backgroundImage: AssetImage(item.photoUrl ?? ''),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description ?? 'Sem descrição',
                  style: const TextStyle(color: Color(0xFFFF8C00), fontSize: 11),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${item.unitPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(color: Colors.orange[800], fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          _buildReactiveQuantityControls(context),
        ],
      ),
    );
  }

  /// Uses BlocBuilder to listen to the CartBloc and calculate the current quantity of THIS specific item in the cart.
  Widget _buildReactiveQuantityControls(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int currentQuantity = 0;
        OrderItemEntity? existingOrderItem;

        if (state is CartUpdated) {
          // Find if this item is already in the global cart
          try {
            existingOrderItem = state.order.items.firstWhere(
                  (orderItem) => orderItem.menuItem.id == item.id,
            );
            currentQuantity = existingOrderItem.quantity;
          } catch (_) {
            // Item not in cart, defaults to 0
          }
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentQuantity > 0) ...[
              GestureDetector(
                onTap: () {
                  if (existingOrderItem != null) {
                    if (currentQuantity == 1) {
                      // Regra: Se tem 1, o botão de menos remove completamente o item
                      context.read<CartBloc>().add(RemoveCartItemEvent(item: existingOrderItem));
                    } else {
                      // Regra: Se tem mais de 1, enviamos uma instrução de decréscimo (delta: -1)
                      final decrementItem = OrderItemEntity(
                          menuItem: item,
                        quantity: -1, // A mágica acontece aqui: somar -1 diminui o valor!
                        unitPrice: item.unitPrice,
                      );
                      context.read<CartBloc>().add(AddCartItemEvent(item: decrementItem));
                    }
                  }
                },
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.remove, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$currentQuantity',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 12),
            ],

            GestureDetector(
              onTap: () {
                final orderItem = OrderItemEntity(
                  menuItem: item,
                  quantity: 1, // Adds 1 unit
                  unitPrice: item.unitPrice,
                );
                context.read<CartBloc>().add(AddCartItemEvent(item: orderItem));
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF10B981),
                child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}