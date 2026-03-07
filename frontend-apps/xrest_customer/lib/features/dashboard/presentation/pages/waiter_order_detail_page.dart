/*
 * File: waiter_order_detail_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Actionable detail view for the Waiter. Allows confirming the
 * delivery of specific items to the table.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/order/domain/entities/order_entity.dart';
import '../../../order/domain/entities/order_item_entity.dart';
import '../../../order/domain/entities/order_item_entity.dart';
import '../state/waiter_dashboard_bloc.dart';
import '../state/waiter_dashboard_event.dart';

class WaiterOrderDetailPage extends StatelessWidget {
  final OrderEntity order;

  const WaiterOrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFF8C00)),
        title: Text('MESA ${order.tableId}', style: const TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: order.items.length,
        separatorBuilder: (_, __) => const Divider(height: 32),
        itemBuilder: (context, index) {
          final item = order.items[index];
          return _buildInteractiveItemRow(context, item);
        },
      ),
    );
  }

  Widget _buildInteractiveItemRow(BuildContext context, OrderItemEntity item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${item.quantity}x', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 18)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.menuItem.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (item.observations != null && item.observations!.isNotEmpty)
                Text('Obs: ${item.observations}', style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildActionWidget(context, item),
      ],
    );
  }

  Widget _buildActionWidget(BuildContext context, OrderItemEntity item) {
    // 1. If it's still preparing in the kitchen
    if (item.status == OrderItemStatus.preparing || item.status == OrderItemStatus.pending) {
      return Column(
        children: const [
          Icon(Icons.hourglass_empty, color: Colors.orange),
          Text('Cozinha', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      );
    }

    // 2. If it's READY to be delivered to the table
    if (item.status == OrderItemStatus.ready) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981), // Green CTA
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: () {
          // Dispatches the event to mark as delivered
          context.read<WaiterDashboardBloc>().add(
            MarkItemAsDeliveredEvent(orderId: order.id ?? '', itemId: item.id ?? ''),
          );
        },
        child: const Text('ENTREGAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
    }

    // 3. If it has already been delivered
    if (item.status == OrderItemStatus.delivered) {
      return Column(
        children: const [
          Icon(Icons.done_all, color: Colors.green),
          Text('Entregue', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}