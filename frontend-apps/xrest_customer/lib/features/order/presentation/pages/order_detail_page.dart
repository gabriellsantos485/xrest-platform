/*
 * File: order_detail_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Detail view showing read-only items and granular status per item.
 */

import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../../domain/entities/order_item_entity.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFF8C00)),
        title: Text('PEDIDO #${order.id}', style: const TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSummary(),
            const Divider(height: 40),
            const Text('Itens do Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildReadOnlyItemList(),
            const Divider(height: 40),
            _buildFinancialSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSummary() {
    return Row(
      children: [
        const Icon(Icons.receipt_long, size: 50, color: Color(0xFFFFC107)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.isTakeaway ? 'Retirada no Balcão' : 'Mesa ${order.tableId}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'Realizado em: ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} às ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyItemList() {
    if (order.items.isEmpty) {
      return const Text('Nenhum item detalhado neste mock.', style: TextStyle(color: Colors.grey));
    }

    return Column(
      children: order.items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item.quantity}x', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF8C00), fontSize: 16)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.menuItem.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    if (item.observations != null && item.observations!.isNotEmpty)
                      Text('Obs: ${item.observations}', style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                    const SizedBox(height: 4),
                    _buildItemStatusTimeline(item.status),
                  ],
                ),
              ),
              Text('R\$ ${item.totalValue.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItemStatusTimeline(OrderItemStatus status) {
    // Shows the specific status of the individual item in the kitchen
    String label = 'Pendente';
    Color color = Colors.grey;

    if (status == OrderItemStatus.preparing) { label = 'Preparando'; color = Colors.orange; }
    if (status == OrderItemStatus.ready) { label = 'Pronto'; color = Colors.green; }

    return Row(
      children: [
        Icon(Icons.sync, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFinancialSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              'R\$ ${order.grandTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF10B981)), // Green
            ),
          ],
        ),
      ],
    );
  }
}