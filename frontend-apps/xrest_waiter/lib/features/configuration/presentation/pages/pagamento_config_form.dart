/*
 * File: pagamento_config_form.dart
 * Author: X-REST Team
 * Description: Formulário de gestão de Formas de Pagamento com layout centralizado
 * e integração completa com a API via PagamentoCacheService.
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../core/cache/pagamento_cache_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../injection_container.dart';
import '../../data/models/pagamento_model.dart';

class PagamentoConfigForm extends StatefulWidget {
  const PagamentoConfigForm({super.key});

  @override
  State<PagamentoConfigForm> createState() => PagamentoConfigFormState();
}

class PagamentoConfigFormState extends State<PagamentoConfigForm> {
  bool _showList = false;
  bool _isLoadingList = false;

  int? _loadedPagamentoId;
  bool _isPagamentoLoaded = false;

  // Controlador
  final _nomeController = TextEditingController();

  // Trava (Read-only)
  bool _lockNome = false;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _loadedPagamentoId = null;
      _isPagamentoLoaded = false;
      _nomeController.clear();
      _lockNome = false;
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
    );
  }

  // --- LÓGICA DE NEGÓCIO ---
  void _onSavePressed() async {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('O campo Nome é obrigatório!'), backgroundColor: Colors.red));
      return;
    }

    _showLoadingDialog();

    final pagamento = PagamentoModel(
      id: _loadedPagamentoId ?? 0,
      nome: _nomeController.text.trim(),
    );

    try {
      bool sucesso;
      if (_loadedPagamentoId != null && _loadedPagamentoId != 0) {
        sucesso = await sl<PagamentoCacheService>().updatePagamento(sl<Dio>(), pagamento);
      } else {
        sucesso = await sl<PagamentoCacheService>().createPagamento(sl<Dio>(), pagamento);
      }

      if (mounted) Navigator.of(context, rootNavigator: true).pop(); // Fecha Loader

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forma de pagamento salva com sucesso! ✅'), backgroundColor: AppColors.primaryGreen));
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar os dados.'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro de conexão com o servidor.'), backgroundColor: Colors.red));
    }
  }

  void _onDeletePressed() async {
    if (_loadedPagamentoId == null) return;

    _showLoadingDialog();

    try {
      bool sucesso = await sl<PagamentoCacheService>().deletePagamento(sl<Dio>(), _loadedPagamentoId!);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forma de pagamento removida! ✅'), backgroundColor: AppColors.primaryGreen));
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao deletar forma de pagamento.'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _toggleView(bool showList) async {
    setState(() {
      _showList = showList;
      if (showList) _isLoadingList = true;
    });

    if (showList) {
      try {
        await sl<PagamentoCacheService>().fetchPagamentosFromServer(sl<Dio>());
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao buscar lista.'), backgroundColor: Colors.red));
      } finally {
        if (mounted) setState(() => _isLoadingList = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CABEÇALHO DE NAVEGAÇÃO
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
          child: Row(
            children: [
              _buildNavButton(label: 'Nova Forma de Pagamento', icon: Icons.add_card, isActive: !_showList, onTap: () => _toggleView(false)),
              const SizedBox(width: 24),
              _buildNavButton(label: 'Meus Pagamentos', icon: Icons.payments_outlined, isActive: _showList, onTap: () => _toggleView(true)),
            ],
          ),
        ),
        const Divider(indent: 32, endIndent: 32, height: 32),

        // CONTEÚDO DINÂMICO
        Expanded(child: _showList ? (_isLoadingList ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)) : _buildPagamentoList()) : _buildFormContent()),
      ],
    );
  }

  Widget _buildNavButton({required String label, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: isActive ? AppColors.primaryOrange.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(icon, color: isActive ? AppColors.primaryOrange : Colors.grey, size: 24),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isActive ? AppColors.primaryOrange : Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // --- TELA DE LISTAGEM ---
  Widget _buildPagamentoList() {
    final pagamentos = sl<PagamentoCacheService>().pagamentosList;
    if (pagamentos.isEmpty) return const Center(child: Text('Nenhuma forma de pagamento encontrada.'));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      itemCount: pagamentos.length,
      itemBuilder: (context, index) {
        final p = pagamentos[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: AppColors.primaryOrange.withOpacity(0.1), child: const Icon(Icons.attach_money, color: AppColors.primaryOrange)),
            title: Text(p.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text('Código: ${p.id.toString().padLeft(4, '0')}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.blueAccent, size: 28),
              onPressed: () {
                setState(() {
                  _showList = false;
                  _isPagamentoLoaded = true;
                  _loadedPagamentoId = p.id;
                  _nomeController.text = p.nome;
                  _lockNome = true;
                });
              },
            ),
          ),
        );
      },
    );
  }

  // --- TELA DE FORMULÁRIO (Layout Centralizado) ---
  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        children: [
          // CONTAINER CENTRALIZADO (Para os Inputs)
          Center(
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  if (_isPagamentoLoaded) ...[
                    const Text('Código', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Text(_loadedPagamentoId?.toString().padLeft(4, '0') ?? '---', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.primaryOrange)),
                    const SizedBox(height: 32),
                  ],
                  _buildVerticalTextField('Nome', _nomeController, _lockNome, () => setState(() => _lockNome = false), maxLength: 60),
                ],
              ),
            ),
          ),

          const SizedBox(height: 100), // Espaçamento para empurrar os botões para baixo

          // BOTÕES ALINHADOS À DIREITA (Conforme o mockup geral do sistema)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_isPagamentoLoaded)
                _buildActionButton('Deletar', Colors.red, _onDeletePressed),
              const SizedBox(width: 16),
              _buildActionButton('Limpar', AppColors.primaryYellow, _clearForm, textColor: Colors.black),
              const SizedBox(width: 16),
              _buildActionButton('Salvar', AppColors.primaryGreen, _onSavePressed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalTextField(String label, TextEditingController controller, bool isLocked, VoidCallback onUnlock, {int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLength: maxLength,
                readOnly: isLocked,
                textAlign: TextAlign.center, // Centraliza o texto digitado
                style: TextStyle(fontFamily: 'Roboto', color: isLocked ? Colors.grey : Colors.black),
                decoration: _inputDecoration(null),
              ),
            ),
            if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint, filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderYellow, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2)),
      counterText: "",
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed, {Color textColor = Colors.white}) => SizedBox(height: 48, width: 140, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: onPressed, child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold))));
}