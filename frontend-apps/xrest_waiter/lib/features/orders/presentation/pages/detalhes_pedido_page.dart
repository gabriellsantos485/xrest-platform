/*
 * File: detalhes_pedido_page.dart
 * Author: X-REST Team
 * Description: Tela de Detalhes do Pedido e PDV (Ponto de Venda).
 * Permite visualizar itens, dividir conta e gerenciar múltiplos pagamentos.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primaryOrange = Color(0xFFFF9800);
const Color primaryGreen = Color(0xFF4CAF50);
const Color textDark = Color(0xFF333333);
const Color borderGray = Color(0xFFE0E0E0);

class DetalhesPedidoPage extends StatefulWidget {
  final int pedidoId; // Futuramente, receberá o ID real ao navegar

  const DetalhesPedidoPage({super.key, this.pedidoId = 3});

  @override
  State<DetalhesPedidoPage> createState() => _DetalhesPedidoPageState();
}

class _DetalhesPedidoPageState extends State<DetalhesPedidoPage> {
  // --- MOCK DO PEDIDO (Baseado no seu JSON) ---
  final Map<String, dynamic> _pedidoMock = {
    "id": 3,
    "status": "ABERTO",
    "clienteNome": "Jhonas Ferreira",
    "mesaId": 1,
    "valorTotal": 74.00,
    "quantidadePessoas": 4,
    "itens": [
      {
        "id": 3, "quantidade": 2, "valorUnitario": 7.00, "valorTotal": 14.00,
        "observacoes": "Sem cebola", "cardapioId": 1, "status": "PRONTO"
      },
      {
        "id": 4, "quantidade": 5, "valorUnitario": 12.00, "valorTotal": 60.00,
        "observacoes": "", "cardapioId": 15, "status": "EM_PREPARO"
      }
    ]
  };

  // --- ESTADO DO PAGAMENTO ---
  int _pessoasNaMesa = 1;
  double _valorTotal = 0.0;

  // Lista de pagamentos já adicionados à conta: [{'metodo': 'PIX', 'valor': 50.00}]
  final List<Map<String, dynamic>> _pagamentosRealizados = [];

  // Controles de Input de Pagamento
  String _metodoSelecionado = 'PIX';
  final List<String> _metodosDisponiveis = ['PIX', 'Cartão de Crédito', 'Cartão de Débito', 'Dinheiro'];
  final _valorPagamentoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pessoasNaMesa = _pedidoMock['quantidadePessoas'] ?? 1;
    if (_pessoasNaMesa < 1) _pessoasNaMesa = 1;
    _valorTotal = _pedidoMock['valorTotal'];
    _atualizarValorSugerido();
  }

  @override
  void dispose() {
    _valorPagamentoController.dispose();
    super.dispose();
  }

  // --- LÓGICA FINANCEIRA ---
  double get _valorPago {
    return _pagamentosRealizados.fold(0.0, (soma, item) => soma + item['valor']);
  }

  double get _valorRestante {
    double restante = _valorTotal - _valorPago;
    return restante > 0 ? restante : 0.0;
  }

  double get _troco {
    double dif = _valorPago - _valorTotal;
    return dif > 0 ? dif : 0.0;
  }

  bool get _podeFinalizar {
    // Tolerância de centavos para erro de float
    return _valorRestante <= 0.01;
  }

  void _atualizarValorSugerido() {
    _valorPagamentoController.text = _valorRestante.toStringAsFixed(2);
  }

  void _adicionarPagamento() {
    double? valorDigitado = double.tryParse(_valorPagamentoController.text.replaceAll(',', '.'));

    if (valorDigitado == null || valorDigitado <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insira um valor válido.'), backgroundColor: Colors.red));
      return;
    }

    if (_valorRestante <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('O pedido já está totalmente pago!'), backgroundColor: Colors.orange));
      return;
    }

    setState(() {
      _pagamentosRealizados.add({
        'metodo': _metodoSelecionado,
        'valor': valorDigitado,
      });
      _atualizarValorSugerido();
    });
  }

  void _removerPagamento(int index) {
    setState(() {
      _pagamentosRealizados.removeAt(index);
      _atualizarValorSugerido();
    });
  }

  // Função provisória para dar nome aos IDs do cardápio
  String _getNomeItemCardapio(int id) {
    switch (id) {
      case 1: return "Coca-Cola Lata 350ml";
      case 15: return "Hambúrguer X-Tudo Artesanal";
      case 12: return "Porção de Batata Frita (Média)";
      default: return "Item Genérico #$id";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: textDark),
        title: Row(
          children: [
            const Text('Resumo do Pedido', style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(12)),
              child: Text('#${_pedidoMock['id'].toString().padLeft(4, '0')}', style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(12)),
              child: Text(_pedidoMock['status'], style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COLUNA ESQUERDA: LISTA DE ITENS
            Expanded(
              flex: 6,
              child: _buildColunaItens(),
            ),
            const SizedBox(width: 24),
            // COLUNA DIREITA: PAINEL DE PAGAMENTO
            Expanded(
              flex: 4,
              child: _buildColunaPagamento(),
            ),
          ],
        ),
      ),
    );
  }

  // --- COLUNA ESQUERDA (ITENS DO PEDIDO) ---
  Widget _buildColunaItens() {
    List<dynamic> itens = _pedidoMock['itens'];

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderGray)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho da Lista
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cliente: ${_pedidoMock['clienteNome'] ?? 'Avulso'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                    const SizedBox(height: 4),
                    Text(_pedidoMock['mesaId'] != null ? 'Mesa: ${_pedidoMock['mesaId']}' : 'Para Viagem', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                Text('${itens.length} itens', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryOrange)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Cabeçalho da Tabela
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, color: textDark))),
                Expanded(flex: 1, child: Text('Qtd', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: textDark))),
                Expanded(flex: 2, child: Text('Status', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: textDark))),
                Expanded(flex: 2, child: Text('Total', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: textDark))),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Lista de Itens
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: itens.length,
              separatorBuilder: (_, __) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final item = itens[index];
                return _buildLinhaItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinhaItem(Map<String, dynamic> item) {
    String nomeProduto = _getNomeItemCardapio(item['cardapioId']);
    String obs = item['observacoes'] ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Nome e Observação
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nomeProduto, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textDark)),
              if (obs.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Obs: $obs', style: TextStyle(fontSize: 12, color: Colors.red.shade400, fontStyle: FontStyle.italic)),
              ]
            ],
          ),
        ),
        // Quantidade
        Expanded(
          flex: 1,
          child: Text('${item['quantidade']}x', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        // Status
        Expanded(
          flex: 2,
          child: Center(child: _buildItemStatusBadge(item['status'])),
        ),
        // Valor
        Expanded(
          flex: 2,
          child: Text('R\$ ${(item['valorTotal'] as double).toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)),
        ),
      ],
    );
  }

  Widget _buildItemStatusBadge(String status) {
    Color bg = Colors.grey.shade200;
    Color text = Colors.grey.shade700;

    if (status == 'EM_PREPARO') { bg = Colors.orange.shade100; text = Colors.orange.shade800; }
    else if (status == 'PRONTO') { bg = Colors.green.shade100; text = Colors.green.shade800; }
    else if (status == 'ENTREGUE') { bg = Colors.blue.shade100; text = Colors.blue.shade800; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(status.replaceAll('_', ' '), style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  // --- COLUNA DIREITA (PAINEL DE PAGAMENTO) ---
  Widget _buildColunaPagamento() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderGray)),
      child: Column(
        children: [
          // Divisão de Contas
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: borderGray))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total do Pedido', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Text('R\$ ${_valorTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dividir por pessoas:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark)),
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.remove_circle_outline, color: primaryOrange), onPressed: () => setState(() { if(_pessoasNaMesa>1) _pessoasNaMesa--; })),
                        Text('$_pessoasNaMesa', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.add_circle_outline, color: primaryOrange), onPressed: () => setState(() { _pessoasNaMesa++; })),
                      ],
                    ),
                  ],
                ),
                if (_pessoasNaMesa > 1) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('R\$ ${(_valorTotal / _pessoasNaMesa).toStringAsFixed(2)} / pessoa', style: TextStyle(fontSize: 14, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ]
              ],
            ),
          ),

          // Lançamento de Pagamento (Múltiplos cartões/pix/etc)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Lançar Pagamento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Dropdown Forma de Pagamento
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          value: _metodoSelecionado,
                          items: _metodosDisponiveis.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                          onChanged: (val) => setState(() => _metodoSelecionado = val!),
                          decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Input Valor
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _valorPagamentoController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                          decoration: InputDecoration(prefixText: 'R\$ ', contentPadding: const EdgeInsets.symmetric(horizontal: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Botão Adicionar
                      Container(
                        decoration: BoxDecoration(color: primaryOrange, borderRadius: BorderRadius.circular(8)),
                        child: IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: _adicionarPagamento),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Lista de Pagamentos Realizados
                  Expanded(
                    child: _pagamentosRealizados.isEmpty
                        ? Center(child: Text('Nenhum pagamento lançado', style: TextStyle(color: Colors.grey.shade400)))
                        : ListView.builder(
                      itemCount: _pagamentosRealizados.length,
                      itemBuilder: (context, index) {
                        final pag = _pagamentosRealizados[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.check_circle, color: primaryGreen),
                          title: Text(pag['metodo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Registrado'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('R\$ ${pag['valor'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _removerPagamento(index)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rodapé Financeiro e Botão Finalizar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)), border: const Border(top: BorderSide(color: borderGray))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pago', style: TextStyle(fontSize: 16)),
                    Text('R\$ ${_valorPago.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_troco > 0 ? 'Troco' : 'Falta Pagar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _troco > 0 ? primaryGreen : Colors.red)),
                    Text('R\$ ${(_troco > 0 ? _troco : _valorRestante).toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _troco > 0 ? primaryGreen : Colors.red)),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _podeFinalizar ? primaryGreen : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _podeFinalizar ? () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pedido Finalizado com Sucesso! ✅'), backgroundColor: primaryGreen));
                      Navigator.pop(context); // Volta para a tela de lista de pedidos
                    } : null,
                    child: const Text('FINALIZAR PAGAMENTO', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}