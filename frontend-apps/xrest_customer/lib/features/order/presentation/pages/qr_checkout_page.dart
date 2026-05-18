/*
 * File: qr_checkout_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-05-15
 * Description: Scans the QR Code and makes a REAL HTTP POST request to the API.
 * Features central visual feedback and preserves the cart on failure.
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; // Importação do pacote HTTP

import '../state/cart_bloc.dart';
import '../state/cart_event.dart';
import '../state/cart_state.dart';

// Enum para controlar a máquina de estados da tela
enum CheckoutStatus { scanning, processing, success, error }

class QrCheckoutPage extends StatefulWidget {
  const QrCheckoutPage({super.key});

  @override
  State<QrCheckoutPage> createState() => _QrCheckoutPageState();
}

class _QrCheckoutPageState extends State<QrCheckoutPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  CheckoutStatus _status = CheckoutStatus.scanning;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  /// Disparado pelo QR Code: Usa a string exata como endpoint de envio
  void _onQrCodeScanned(String endpointUrl) {
    if (_status != CheckoutStatus.scanning) return;
    _submitOrder(endpointUrl);
  }

  /// Disparado pelo Fallback Manual
  void _onManualEntry(String tableNumber) {
    if (_status != CheckoutStatus.scanning) return;

    // ATENÇÃO (Dica de Arquitetura para testes locais):
    // Se você estiver testando no Emulador Android, "localhost" não funciona (aponta para o próprio celular).
    // Use "10.0.2.2" no lugar de "localhost" para o emulador enxergar seu PC.
    // Se for celular físico, use o IP da sua máquina na rede Wi-Fi (Ex: 192.168.1.15).
    final endpointUrl = 'http://10.0.2.2:8080/xrest/v1/pedidos/mesa/$tableNumber/pedido';
    _submitOrder(endpointUrl);
  }

  Future<void> _submitOrder(String endpointUrl) async {
    setState(() => _status = CheckoutStatus.processing);

    final cartState = context.read<CartBloc>().state;
    if (cartState is! CartUpdated || cartState.order.items.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final order = cartState.order;

    // Constrói os itens exatamente como seu backend exige
    final List<Map<String, dynamic>> itensPedido = order.items.map((item) {
      return {
        "cardapioId": item.menuItem.id,
        "quantidade": item.quantity,
        "observacoes": item.observations ?? ""
      };
    }).toList();

    // Payload final do JSON
    final Map<String, dynamic> payload = {
      "viagem": order.isTakeaway,
      "quantidadePessoas": 4,
      "clienteId": 1,
      "mesaId": 1,            // Opcional, dependendo da sua API
      "funcionarioId": 2,
      "itensPedido": itensPedido
    };

    debugPrint('POST para: $endpointUrl');
    debugPrint('Payload: ${jsonEncode(payload)}');

    try {
      // ---------------------------------------------------------
      // A REQUISIÇÃO HTTP REAL PARA SUA API SPRING BOOT
      // ---------------------------------------------------------

      // Converte a String do QR Code para um objeto Uri
      final uri = Uri.parse(endpointUrl);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          // Se sua API tiver segurança (Spring Security / JWT), o token entraria aqui:
          // 'Authorization': 'Bearer $seuToken',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 15)); // Timeout de segurança (15s)

      debugPrint('Status Code da API: ${response.statusCode}');

      // Verifica se a API retornou Sucesso (200 OK ou 201 Created)
      if (response.statusCode == 200 || response.statusCode == 201) {

        // 1. SUCESSO: Atualiza a interface para o check verde
        setState(() => _status = CheckoutStatus.success);

        // 2. Limpa a sacola APENAS após a confirmação do Backend
        if (mounted) {
          context.read<CartBloc>().add(const ClearCartEvent());
        }

        // 3. Aguarda 2 segundos para o cliente ver o check e sai da tela
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }

      } else {
        // Se a API retornou 400 (Bad Request), 404 (Not Found), 500 (Internal Server Error)
        debugPrint('Erro da API: ${response.body}');
        throw Exception('Erro na requisição: ${response.statusCode}');
      }

    } catch (e) {
      // ---------------------------------------------------------
      // TRATAMENTO DE FALHA (Sem limpar a sacola)
      // ---------------------------------------------------------
      debugPrint('Falha ao enviar pedido: $e');

      // Atualiza a interface para a carinha triste
      if (mounted) {
        setState(() => _status = CheckoutStatus.error);
      }
    }
  }

  void _showManualEntryDialog() {
    final TextEditingController tableCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Inserir Mesa Manualmente'),
          content: TextField(
            controller: tableCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Número da mesa (Ex: 1)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00)),
              onPressed: () {
                Navigator.pop(dialogContext);
                if (tableCtrl.text.trim().isNotEmpty) {
                  _onManualEntry(tableCtrl.text.trim());
                }
              },
              child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('CONFIRMAR MESA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // CAMADA 1: A Câmera
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                _onQrCodeScanned(barcodes.first.rawValue!);
              }
            },
          ),

          // CAMADA 2: O Guia Visual (Só aparece se estiver a escanear)
          if (_status == CheckoutStatus.scanning) ...[
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFF8C00), width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Positioned(
              bottom: 60,
              child: Column(
                children: [
                  const Text(
                    'Aponte para o QR Code da sua mesa',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: _showManualEntryDialog,
                    icon: const Icon(Icons.keyboard, color: Colors.white),
                    label: const Text(
                      'Inserir Manualmente',
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // CAMADA 3: Feedbacks Visuais Centralizados (Loading, Sucesso ou Erro)
          if (_status != CheckoutStatus.scanning)
            Container(
              color: Colors.black87,
              width: double.infinity,
              height: double.infinity,
              child: _buildStatusOverlay(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusOverlay() {
    if (_status == CheckoutStatus.processing) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFFF8C00)),
          SizedBox(height: 24),
          Text('Enviando pedido para a cozinha...', style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      );
    }

    if (_status == CheckoutStatus.success) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Color(0xFF10B981), size: 150),
          SizedBox(height: 24),
          Text(
            'Pedido Enviado!',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    if (_status == CheckoutStatus.error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent, size: 150),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Não foi possível enviar seu pedido.\nTente Novamente.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C00),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Tentar Novamente', style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () {
              // Volta o estado para escanear sem perder os dados da sacola
              setState(() => _status = CheckoutStatus.scanning);
            },
          )
        ],
      );
    }

    return const SizedBox.shrink();
  }
}