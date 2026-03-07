/*
 * File: qr_checkout_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-07
 * Description: Final step of checkout. Uses the device camera via mobile_scanner
 * to read the table's QR Code, mapping the order to a physical location. Includes a manual fallback.
 */

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/cart_bloc.dart';
import '../state/cart_event.dart';

class QrCheckoutPage extends StatefulWidget {
  const QrCheckoutPage({super.key});

  @override
  State<QrCheckoutPage> createState() => _QrCheckoutPageState();
}

class _QrCheckoutPageState extends State<QrCheckoutPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  /// Handles the table identification (via QR code or manual entry)
  void _processTableAssignment(String tableRawData) {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    // Lógica de parse simulada. Em um cenário real, você faria o parse de um JSON ou URI.
    final int tableId = int.tryParse(tableRawData) ?? 1;

    _finalizeOrderAndNavigate(tableId);
  }

  void _finalizeOrderAndNavigate(int tableId) {
    // 1. Aqui você conectará com o Backend chamando o método de submitOrder() da API.

    // 2. Limpa o carrinho após o sucesso
    context.read<CartBloc>().add(const ClearCartEvent());

    // 3. Exibe mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedido enviado com sucesso para a Mesa $tableId!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    // 4. Retorna para a tela inicial (Cardápio)
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// Dialog para entrada manual (Fallback em caso de falha da câmera ou QR Code rasurado)
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
              hintText: 'Ex: 12',
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
                _processTableAssignment(tableCtrl.text.trim());
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
          // 1. A Câmera
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                _processTableAssignment(barcodes.first.rawValue!);
              }
            },
          ),

          // 2. O Guia Visual (Quadrado de foco)
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFF8C00), width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // 3. Texto de Instrução e Botão de Fallback Manual
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
      ),
    );
  }
}