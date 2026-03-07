/*
 * File: cart_summary_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-07
 * Description: Cart summary screen. Features standard item removal and
 * routes to the QR Code checkout flow for table assignment.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/cart_bloc.dart';
import '../state/cart_event.dart';
import '../state/cart_state.dart';
import 'qr_checkout_page.dart';

class CartSummaryPage extends StatelessWidget {
  const CartSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFF8C00)),
        title: const Text(
          'MINHA SACOLA',
          style: TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial || (state is CartUpdated && state.order.items.isEmpty)) {
            return const Center(
              child: Text(
                'Sua sacola está vazia.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          if (state is CartUpdated) {
            final order = state.order;

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: order.items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          item.menuItem.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Qtd: ${item.quantity}  •  Unit: R\$ ${item.unitPrice.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Exibe o valor total do item e a lixeira simples
                            Text(
                              'R\$ ${item.totalValue.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () {
                                context.read<CartBloc>().add(RemoveCartItemEvent(item: item));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _buildCheckoutSection(context, order.grandTotal),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, double grandTotal) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -5)),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total do Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  'R\$ ${grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981), // Green CTA
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // Redireciona para o fluxo de QR Code
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QrCheckoutPage()),
                  );
                },
                child: const Text('Confirmar Pedido', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}