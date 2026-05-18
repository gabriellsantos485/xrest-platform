/*
 * File: pedidos_page.dart
 * Author: X-REST Team
 * Description: Tela de Pedidos com Lista e Detalhes (PDV) integrados na mesma view
 * para preservar o layout base. Busca pagamentos reais do PagamentoCacheService.
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../core/cache/pedido_cache_service.dart';
import '../../../../core/cache/pagamento_cache_service.dart';
import '../../../../injection_container.dart';
import '../../data/models/pedido_model.dart';

const Color primaryOrange = Color(0xFFFF9800);
const Color primaryGreen = Color(0xFF4CAF50);
const Color textDark = Color(0xFF333333);
const Color borderGray = Color(0xFFE0E0E0);

enum PedidosViewState { list, details }

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  // Controle de Tela
  PedidosViewState _currentView = PedidosViewState.list;
  PedidoModel? _pedidoSelecionado;

  // Filtros da Lista
  String _selectedFilter = 'Todos';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _isLoading = false;
  String _sortColumn = 'Data/Hora';
  bool _isAscending = false;

  // Variáveis do PDV (Detalhes/Pagamento)
  int _pessoasNaMesa = 1;
  final List<Map<String, dynamic>> _pagamentosRealizados = [];
  String? _metodoSelecionado;
  final _valorPagamentoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPedidos();
    _fetchMetodosPagamento();
  }

  @override
  void dispose() {
    _valorPagamentoController.dispose();
    super.dispose();
  }

  // --- REQUISIÇÕES DE API ---
  Future<void> _fetchPedidos() async {
    setState(() => _isLoading = true);
    try {
      await sl<PedidoCacheService>().fetchPedidosByDate(sl<Dio>(), _startDate, _endDate);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao carregar pedidos.'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMetodosPagamento() async {
    // Busca os métodos de pagamento reais se a lista estiver vazia
    if (sl<PagamentoCacheService>().pagamentosList.isEmpty) {
      try {
        await sl<PagamentoCacheService>().fetchPagamentosFromServer(sl<Dio>());
      } catch (e) {
        print("Erro ao buscar métodos de pagamento");
      }
    }
  }

  // --- SELETORES DE DATA ---
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _startDate, firstDate: DateTime(2020), lastDate: DateTime(2100), builder: _datePickerTheme);
    if (picked != null && picked != _startDate) {
      DateTime dataEscolhida = DateTime(picked.year, picked.month, picked.day);
      DateTime dataFimAtual = DateTime(_endDate.year, _endDate.month, _endDate.day);
      if (dataEscolhida.isAfter(dataFimAtual)) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Início não pode ser maior que o Fim!'), backgroundColor: Colors.orange));
        return;
      }
      setState(() => _startDate = picked);
      _fetchPedidos();
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _endDate, firstDate: DateTime(2020), lastDate: DateTime(2100), builder: _datePickerTheme);
    if (picked != null && picked != _endDate) {
      DateTime dataEscolhida = DateTime(picked.year, picked.month, picked.day);
      DateTime dataInicioAtual = DateTime(_startDate.year, _startDate.month, _startDate.day);
      if (dataEscolhida.isBefore(dataInicioAtual)) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fim não pode ser menor que o Início!'), backgroundColor: Colors.orange));
        return;
      }
      setState(() => _endDate = picked);
      _fetchPedidos();
    }
  }

  Widget _datePickerTheme(BuildContext context, Widget? child) {
    return Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: primaryOrange, onPrimary: Colors.white, onSurface: textDark)), child: child!);
  }

  // --- LÓGICA DO PAGAMENTO (PDV) ---
  double get _valorPago => _pagamentosRealizados.fold(0.0, (soma, item) => soma + item['valor']);
  double get _valorRestante {
    if (_pedidoSelecionado == null) return 0.0;
    double restante = _pedidoSelecionado!.valorTotal - _valorPago;
    return restante > 0 ? restante : 0.0;
  }
  double get _troco {
    if (_pedidoSelecionado == null) return 0.0;
    double dif = _valorPago - _pedidoSelecionado!.valorTotal;
    return dif > 0 ? dif : 0.0;
  }
  bool get _podeFinalizar => _valorRestante <= 0.01;

  void _atualizarValorSugerido() {
    _valorPagamentoController.text = _valorRestante.toStringAsFixed(2);
  }

  void _abrirDetalhes(PedidoModel pedido) {
    setState(() {
      _pedidoSelecionado = pedido;
      _pessoasNaMesa = pedido.quantidadePessoas ?? 1;
      if (_pessoasNaMesa < 1) _pessoasNaMesa = 1;
      _pagamentosRealizados.clear();
      _currentView = PedidosViewState.details;

      final metodos = sl<PagamentoCacheService>().pagamentosList;
      _metodoSelecionado = metodos.isNotEmpty ? metodos.first.nome : null;
    });
    _atualizarValorSugerido();
  }

  void _fecharDetalhes() {
    setState(() {
      _currentView = PedidosViewState.list;
      _pedidoSelecionado = null;
    });
    _fetchPedidos(); // Atualiza a lista caso o pagamento tenha alterado o status
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
    if (_metodoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um método de pagamento.'), backgroundColor: Colors.orange));
      return;
    }

    setState(() {
      _pagamentosRealizados.add({'metodo': _metodoSelecionado, 'valor': valorDigitado});
      _atualizarValorSugerido();
    });
  }

  void _removerPagamento(int index) {
    setState(() {
      _pagamentosRealizados.removeAt(index);
      _atualizarValorSugerido();
    });
  }

  // --- RENDERIZAÇÃO PRINCIPAL ---
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_currentView == PedidosViewState.details) ...[
                IconButton(icon: const Icon(Icons.arrow_back, color: textDark, size: 28), onPressed: _fecharDetalhes),
                const SizedBox(width: 8),
              ],
              Text(_currentView == PedidosViewState.list ? 'PEDIDOS' : 'RESUMO DO PEDIDO', style: const TextStyle(color: primaryOrange, fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: _currentView == PedidosViewState.list ? _buildListaView() : _buildDetailsView(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 1: LISTAGEM DE PEDIDOS
  // ==========================================
  Widget _buildListaView() {
    return Column(
      children: [
        _buildFilterBar(),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildToolbar(),
                const Divider(height: 1, thickness: 1),
                _buildTableHeader(),
                const Divider(height: 1, thickness: 1),
                Expanded(child: _isLoading ? const Center(child: CircularProgressIndicator(color: primaryOrange)) : _buildTableBody()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // (MÉTODOS DA LISTA OMISSOS AQUI POR BREVIDADE, MAS MANTIDOS DO CÓDIGO ANTERIOR)
  // Reutilizando os mesmos métodos de _buildFilterBar, _buildToolbar, _buildTableHeader, _buildTableBody...
  Widget _buildFilterBar() {
    final todos = sl<PedidoCacheService>().pedidosList;
    int concluidos = todos.where((p) => p.status == 'CONCLUÍDO').length;
    int abertos = todos.where((p) => p.status == 'ABERTO').length;
    int cancelados = todos.where((p) => p.status == 'CANCELADO').length;

    final filtros = [
      {'name': 'Todos', 'count': todos.length},
      {'name': 'Aberto', 'count': abertos},
      {'name': 'Concluídos', 'count': concluidos},
      {'name': 'Cancelado', 'count': cancelados},
    ];

    return Container(
      height: 40, decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: filtros.map((filtro) {
          final isSelected = _selectedFilter == filtro['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filtro['name'] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: isSelected ? Colors.blue : Colors.transparent, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Text(filtro['name'].toString(), style: TextStyle(color: isSelected ? Colors.white : textDark, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  const SizedBox(width: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.grey.shade300, borderRadius: BorderRadius.circular(12)), child: Text(filtro['count'].toString(), style: TextStyle(color: isSelected ? Colors.blue : textDark, fontWeight: FontWeight.bold, fontSize: 12)))
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Pesquisar...', prefixIcon: Icon(Icons.search, color: Colors.grey), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 8)))),
          InkWell(onTap: _selectStartDate, borderRadius: BorderRadius.circular(8), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.calendar_month, size: 18, color: primaryOrange), const SizedBox(width: 8), Text('Início: ${DateFormat('dd/MM/yyyy').format(_startDate)}', style: const TextStyle(color: textDark, fontSize: 13, fontWeight: FontWeight.bold))]))),
          const SizedBox(width: 12),
          InkWell(onTap: _selectEndDate, borderRadius: BorderRadius.circular(8), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.calendar_month, size: 18, color: primaryOrange), const SizedBox(width: 8), Text('Fim: ${DateFormat('dd/MM/yyyy').format(_endDate)}', style: const TextStyle(color: textDark, fontSize: 13, fontWeight: FontWeight.bold))]))),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: Colors.grey.shade50, padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildHeaderCell('Pedido', 1), _buildVerticalDivider(),
          _buildHeaderCell('Data/Hora', 2), _buildVerticalDivider(),
          _buildHeaderCell('Status', 1), _buildVerticalDivider(),
          _buildHeaderCell('Mesa', 1), _buildVerticalDivider(),
          _buildHeaderCell('Cliente', 2), _buildVerticalDivider(),
          _buildHeaderCell('Valor Total', 1),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, int flex) {
    bool isSelected = _sortColumn == text;
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => setState(() {
          if (_sortColumn == text) _isAscending = !_isAscending; else { _sortColumn = text; _isAscending = true; }
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Flexible(child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis)), const SizedBox(width: 4), Icon(isSelected ? (_isAscending ? Icons.arrow_upward : Icons.arrow_downward) : Icons.unfold_more, size: 16, color: isSelected ? primaryOrange : Colors.grey.shade400)]),
        ),
      ),
    );
  }

  Widget _buildTableBody() {
    final todos = sl<PedidoCacheService>().pedidosList;
    List<PedidoModel> pedidos = _selectedFilter == 'Todos' ? List.from(todos) : todos.where((p) => p.status == (_selectedFilter.toUpperCase() == 'CONCLUÍDOS' ? 'CONCLUÍDO' : _selectedFilter.toUpperCase())).toList();

    pedidos.sort((a, b) {
      int res = 0;
      switch (_sortColumn) {
        case 'Pedido': res = a.id.compareTo(b.id); break;
        case 'Data/Hora': res = a.criadoEm.compareTo(b.criadoEm); break;
        case 'Status': res = a.status.compareTo(b.status); break;
        case 'Mesa': res = (a.mesaId ?? 999).compareTo(b.mesaId ?? 999); break;
        case 'Cliente': res = (a.clienteNome ?? '').compareTo(b.clienteNome ?? ''); break;
        case 'Valor Total': res = a.valorTotal.compareTo(b.valorTotal); break;
      }
      return _isAscending ? res : -res;
    });

    if (pedidos.isEmpty) return const Center(child: Text('Nenhum pedido encontrado.'));

    return ListView.separated(
      itemCount: pedidos.length, separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        DateTime dataParsed = DateTime.tryParse(pedido.criadoEm) ?? DateTime.now();
        String dataExibicao = DateFormat('dd/MM/yyyy HH:mm').format(dataParsed);

        return IntrinsicHeight(
          child: Row(
            children: [
              Expanded(flex: 1, child: Center(child: InkWell(onTap: () => _abrirDetalhes(pedido), child: Text(pedido.id.toString().padLeft(3, '0'), style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))))),
              _buildVerticalDivider(), Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(12), child: Text(dataExibicao, textAlign: TextAlign.center))),
              _buildVerticalDivider(), Expanded(flex: 1, child: Center(child: _buildStatusBadge(pedido.status))),
              _buildVerticalDivider(), Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(12), child: Text(pedido.mesaId?.toString() ?? 'Viagem', textAlign: TextAlign.center))),
              _buildVerticalDivider(), Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(12), child: Text(pedido.clienteNome ?? 'Avulso', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis))),
              _buildVerticalDivider(), Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(12), child: Text('R\$ ${pedido.valorTotal.toStringAsFixed(2)}', textAlign: TextAlign.center))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerticalDivider() => Container(width: 1, color: Colors.grey.shade400);

  Widget _buildStatusBadge(String status) {
    Color bg = Colors.grey.shade200; Color text = Colors.grey.shade700;
    if (status == 'CONCLUÍDO') { bg = Colors.green.shade100; text = Colors.green.shade800; }
    else if (status == 'CANCELADO') { bg = Colors.red.shade100; text = Colors.red.shade800; }
    else if (status == 'ABERTO') { bg = Colors.orange.shade100; text = Colors.orange.shade800; }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)), child: Text(status, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 12)));
  }

  // ==========================================
  // VIEW 2: DETALHES DO PEDIDO (PDV Integrado)
  // ==========================================
  Widget _buildDetailsView() {
    if (_pedidoSelecionado == null) return const SizedBox();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ----------------------------------------------------
        // COLUNA ESQUERDA: ITENS DO PEDIDO
        // ----------------------------------------------------
        Expanded(
          flex: 6,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderGray)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cliente: ${_pedidoSelecionado!.clienteNome ?? 'Avulso'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                          const SizedBox(height: 4),
                          Text(_pedidoSelecionado!.mesaId != null ? 'Mesa: ${_pedidoSelecionado!.mesaId}' : 'Para Viagem', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                      Text('${_pedidoSelecionado!.itens.length} itens', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryOrange)),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                Container(
                  color: Colors.grey.shade50, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _pedidoSelecionado!.itens.length,
                    separatorBuilder: (_, __) => const Divider(height: 32),
                    itemBuilder: (context, index) {
                      final item = _pedidoSelecionado!.itens[index];
                      // Ajustado para refletir a sua alteração para cardapioName (String)
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Utilizando a sua propriedade cardapioName
                                    Text(item.cardapioName ?? 'Item sem nome', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textDark)),
                                    if (item.observacoes.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text('Obs: ${item.observacoes}', style: TextStyle(fontSize: 12, color: Colors.red.shade400, fontStyle: FontStyle.italic))
                                    ]
                                  ]
                              )
                          ),
                          Expanded(flex: 1, child: Text('${item.quantidade}x', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey))),
                          Expanded(flex: 2, child: Center(child: _buildItemStatusBadge(item.status))),
                          Expanded(flex: 2, child: Text('R\$ ${item.valorTotal.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark))),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),

        // ----------------------------------------------------
        // COLUNA DIREITA: PAINEL DE PAGAMENTO (C/ Correção de Overflow)
        // ----------------------------------------------------
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderGray)),
            child: Column(
              children: [
                // CABEÇALHO (Fixo)
                Container(
                  padding: const EdgeInsets.all(16), // Reduzido de 24
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: borderGray))),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total do Pedido', style: TextStyle(fontSize: 18, color: Colors.grey)), Text('R\$ ${_pedidoSelecionado!.valorTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark))]),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Dividir por:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark)),
                          Row(children: [IconButton(icon: const Icon(Icons.remove_circle_outline, color: primaryOrange), onPressed: () => setState(() { if(_pessoasNaMesa>1) _pessoasNaMesa--; })), Text('$_pessoasNaMesa', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.add_circle_outline, color: primaryOrange), onPressed: () => setState(() { _pessoasNaMesa++; }))]),
                        ],
                      ),
                      if (_pessoasNaMesa > 1) Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text('R\$ ${(_pedidoSelecionado!.valorTotal / _pessoasNaMesa).toStringAsFixed(2)} / pessoa', style: TextStyle(fontSize: 14, color: Colors.blue.shade700, fontWeight: FontWeight.bold))]),
                    ],
                  ),
                ),

                // MIOLO (Rolável - Evita o Overflow!)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lançar Pagamento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true, // Evita overflow horizontal de textos longos
                                value: _metodoSelecionado,
                                items: sl<PagamentoCacheService>().pagamentosList.map((p) => DropdownMenuItem(value: p.nome, child: Text(p.nome, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis))).toList(),
                                onChanged: (val) => setState(() => _metodoSelecionado = val),
                                decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                flex: 2,
                                child: TextField(
                                    controller: _valorPagamentoController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                    decoration: InputDecoration(isDense: true, prefixText: 'R\$ ', contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))
                                )
                            ),
                            const SizedBox(width: 8),
                            Container(height: 42, decoration: BoxDecoration(color: primaryOrange, borderRadius: BorderRadius.circular(8)), child: IconButton(icon: const Icon(Icons.add, color: Colors.white, size: 20), onPressed: _adicionarPagamento)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Lista de pagamentos usando shrinkWrap
                        _pagamentosRealizados.isEmpty
                            ? Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Nenhum pagamento lançado', style: TextStyle(color: Colors.grey.shade400))))
                            : ListView.builder(
                          shrinkWrap: true, // Importante: Permite que a lista cresça dentro do ScrollView
                          physics: const NeverScrollableScrollPhysics(), // Quem rola é o SingleChildScrollView pai
                          itemCount: _pagamentosRealizados.length,
                          itemBuilder: (context, index) {
                            final pag = _pagamentosRealizados[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero, leading: const Icon(Icons.check_circle, color: primaryGreen),
                              title: Text(pag['metodo'], style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text('R\$ ${pag['valor'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _removerPagamento(index))]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // RODAPÉ (Fixo - Finalizar)
                Container(
                  padding: const EdgeInsets.all(16), // Reduzido de 24
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)), border: const Border(top: BorderSide(color: borderGray))),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total Pago', style: TextStyle(fontSize: 16)), Text('R\$ ${_valorPago.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark))]),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_troco > 0 ? 'Troco' : 'Falta Pagar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _troco > 0 ? primaryGreen : Colors.red)), Text('R\$ ${(_troco > 0 ? _troco : _valorRestante).toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _troco > 0 ? primaryGreen : Colors.red))]),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity, height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: _podeFinalizar ? primaryGreen : Colors.grey.shade400, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: _podeFinalizar ? () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pedido Finalizado! ✅'), backgroundColor: primaryGreen));
                            _fecharDetalhes();
                          } : null,
                          child: const Text('FINALIZAR PAGAMENTO', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemStatusBadge(String status) {
    Color bg = Colors.grey.shade200; Color text = Colors.grey.shade700;
    if (status == 'EM_PREPARO') { bg = Colors.orange.shade100; text = Colors.orange.shade800; }
    else if (status == 'PRONTO') { bg = Colors.green.shade100; text = Colors.green.shade800; }
    else if (status == 'ENTREGUE') { bg = Colors.blue.shade100; text = Colors.blue.shade800; }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)), child: Text(status.replaceAll('_', ' '), style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)));
  }
}