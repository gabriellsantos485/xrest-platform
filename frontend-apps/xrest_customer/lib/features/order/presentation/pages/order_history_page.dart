/*
 * File: order_history_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Master view for Order History. Uses a TabBar to elegantly separate active from past orders.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../state/history/order_history_bloc.dart';
import '../state/history/order_history_state.dart';
import '../../domain/entities/order_entity.dart';
import 'order_detail_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    // JIT Fetching for history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderHistoryBloc>().add(FetchOrderHistoryEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Active and Past
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('MEUS PEDIDOS', style: TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: Color(0xFFFF8C00),
            labelColor: Color(0xFFFF8C00),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Em Andamento'),
              Tab(text: 'Concluídos'),
            ],
          ),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading || state is OrderHistoryInitial) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFFF8C00)));
            }

            if (state is OrderHistoryLoaded) {
              return TabBarView(
                children: [
                  _buildOrderList(state.activeOrders, 'Nenhum pedido em andamento no momento.'),
                  _buildOrderList(state.pastOrders, 'Você ainda não possui histórico de pedidos.'),
                ],
              );
            }

            return const Center(child: Text('Erro ao carregar histórico.'));
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderEntity> orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(child: Text(emptyMessage, style: const TextStyle(color: Colors.grey, fontSize: 16)));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Push to the Detail View
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderDetailPage(order: order)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pedido #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  _buildStatusBadge(order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${order.items.length} itens', style: const TextStyle(color: Colors.black87)),
                  Text(
                    'R\$ ${order.grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case OrderStatus.inProgress:
        bgColor = Colors.orange[100]!; textColor = Colors.orange[800]!; label = 'Preparando'; break;
      case OrderStatus.closed:
        bgColor = Colors.green[100]!; textColor = Colors.green[800]!; label = 'Concluído'; break;
      case OrderStatus.canceled:
        bgColor = Colors.red[100]!; textColor = Colors.red[800]!; label = 'Cancelado'; break;
      default:
        bgColor = Colors.grey[200]!; textColor = Colors.grey[800]!; label = 'Aguardando';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}