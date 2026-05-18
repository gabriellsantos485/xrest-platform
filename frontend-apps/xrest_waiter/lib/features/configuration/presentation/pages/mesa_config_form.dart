/*
 * File: mesa_config_form.dart
 * Author: X-REST Team
 * Description: Gestão de Mesas integrada ao MesaCacheService (CRUD completo).
 * Layout centralizado conforme mockup, com suporte a Enums e validação.
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/cache/mesa_cache_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../data/models/mesa_model.dart';


class MesaConfigForm extends StatefulWidget {
  const MesaConfigForm({super.key});

  @override
  State<MesaConfigForm> createState() => MesaConfigFormState();
}

class MesaConfigFormState extends State<MesaConfigForm> {
  bool _showList = false;
  bool _isLoadingList = false;

  int? _loadedMesaId;
  bool _isMesaLoaded = false;

  // Controladores
  final _capacidadeController = TextEditingController();
  String? _selectedStatus;
  String? _selectedLocalizacao;

  // Travas (Read-only)
  bool _lockStatus = false;
  bool _lockLocalizacao = false;
  bool _lockCapacidade = false;

  // Opções Visuais
  final List<String> _statusOptions = ['Livre', 'Em Limpeza', 'Lotada', 'Reservada', 'Manutenção'];
  final List<String> _locOptions = ['Primeiro Andar', 'Segundo Andar'];

  @override
  void dispose() {
    _capacidadeController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _loadedMesaId = null;
      _isMesaLoaded = false;
      _capacidadeController.clear();
      _selectedStatus = null;
      _selectedLocalizacao = null;
      _lockStatus = _lockLocalizacao = _lockCapacidade = false;
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
    );
  }

  // --- LÓGICA DE NEGÓCIO: SALVAR (POST/PUT) ---
  void _onSavePressed() async {
    if (_selectedStatus == null || _selectedLocalizacao == null || _capacidadeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos!'), backgroundColor: Colors.red));
      return;
    }

    final capValue = int.tryParse(_capacidadeController.text) ?? 0;
    if (capValue <= 0 || capValue > 20) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Capacidade inválida (1-20).'), backgroundColor: Colors.orange));
      return;
    }

    _showLoadingDialog();

    // Mapeamento Frontend -> Backend
    String statusDB = '';
    switch (_selectedStatus) {
      case 'Livre': statusDB = 'LIVRE'; break;
      case 'Em Limpeza': statusDB = 'EM_LIMPEZA'; break;
      case 'Lotada': statusDB = 'LOTADA'; break;
      case 'Reservada': statusDB = 'RESERVADA'; break;
      case 'Manutenção': statusDB = 'MANUTENCAO'; break;
    }
    String locDB = _selectedLocalizacao == 'Primeiro Andar' ? 'P' : 'S';

    final mesa = MesaModel(
      id: _loadedMesaId ?? 0,
      status: statusDB,
      localizacao: locDB,
      capacidade: capValue,
    );

    try {
      bool sucesso;
      if (_loadedMesaId != null && _loadedMesaId != 0) {
        sucesso = await sl<MesaCacheService>().updateMesa(sl<Dio>(), mesa);
      } else {
        sucesso = await sl<MesaCacheService>().createMesa(sl<Dio>(), mesa);
      }

      if (mounted) Navigator.of(context, rootNavigator: true).pop(); // Fecha Loader

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mesa salva com sucesso! ✅'), backgroundColor: AppColors.primaryGreen));
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar mesa.'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro de conexão.'), backgroundColor: Colors.red));
    }
  }

  // --- LÓGICA DE NEGÓCIO: DELETAR ---
  void _onDeletePressed() async {
    if (_loadedMesaId == null) return;
    _showLoadingDialog();
    try {
      bool sucesso = await sl<MesaCacheService>().deleteMesa(sl<Dio>(), _loadedMesaId!);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mesa removida! ✅'), backgroundColor: AppColors.primaryGreen));
        _clearForm();
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // Alternar Visualização e Sincronizar
  void _toggleView(bool showList) async {
    setState(() {
      _showList = showList;
      if (showList) _isLoadingList = true;
    });

    if (showList) {
      try {
        await sl<MesaCacheService>().fetchMesasFromServer(sl<Dio>());
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao buscar mesas.'), backgroundColor: Colors.red));
      } finally {
        if (mounted) setState(() => _isLoadingList = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
          child: Row(
            children: [
              _buildNavButton(label: 'Nova Mesa', icon: Icons.add_circle_outline, isActive: !_showList, onTap: () => _toggleView(false)),
              const SizedBox(width: 24),
              _buildNavButton(label: 'Minhas Mesas', icon: Icons.table_restaurant_outlined, isActive: _showList, onTap: () => _toggleView(true)),
            ],
          ),
        ),
        const Divider(indent: 32, endIndent: 32, height: 32),
        Expanded(child: _showList ? (_isLoadingList ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)) : _buildMesaList()) : _buildFormContent()),
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

  Widget _buildMesaList() {
    final mesas = sl<MesaCacheService>().mesasList;
    if (mesas.isEmpty) return const Center(child: Text('Nenhuma mesa encontrada.'));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      itemCount: mesas.length,
      itemBuilder: (context, index) {
        final m = mesas[index];
        String locText = m.localizacao == 'P' ? '1º Andar' : '2º Andar';
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: AppColors.primaryOrange.withOpacity(0.1), child: const Icon(Icons.table_restaurant, color: AppColors.primaryOrange)),
            title: Text('Mesa ${m.id.toString().padLeft(3, '0')}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Status: ${m.status} • Cap: ${m.capacidade} • $locText'),
            trailing: IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.blueAccent, size: 28),
              onPressed: () {
                setState(() {
                  _showList = false;
                  _isMesaLoaded = true;
                  _loadedMesaId = m.id;
                  _capacidadeController.text = m.capacidade.toString();

                  // Backend Enum -> UI String
                  if (m.status == 'LIVRE') _selectedStatus = 'Livre';
                  else if (m.status == 'EM_LIMPEZA') _selectedStatus = 'Em Limpeza';
                  else if (m.status == 'LOTADA') _selectedStatus = 'Lotada';
                  else if (m.status == 'RESERVADA') _selectedStatus = 'Reservada';
                  else if (m.status == 'MANUTENCAO') _selectedStatus = 'Manutenção';

                  _selectedLocalizacao = m.localizacao == 'P' ? 'Primeiro Andar' : 'Segundo Andar';
                  _lockStatus = _lockLocalizacao = _lockCapacidade = true;
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            children: [
              if (_isMesaLoaded) ...[
                const Text('Código', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(_loadedMesaId?.toString().padLeft(4, '0') ?? '---', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.primaryOrange)),
                const SizedBox(height: 32),
              ],
              _buildVerticalDropdown('Status', _statusOptions, _selectedStatus, _lockStatus, () => setState(() => _lockStatus = false), (val) => setState(() => _selectedStatus = val)),
              _buildVerticalDropdown('Localização', _locOptions, _selectedLocalizacao, _lockLocalizacao, () => setState(() => _lockLocalizacao = false), (val) => setState(() => _selectedLocalizacao = val)),
              _buildVerticalTextField('Capacidade', _capacidadeController, _lockCapacidade, () => setState(() => _lockCapacidade = false), maxLength: 2, keyboardType: TextInputType.number, customFormatters: [FilteringTextInputFormatter.digitsOnly]),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isMesaLoaded) Expanded(child: _buildActionButton('Deletar', Colors.red, _onDeletePressed)),
                  if (_isMesaLoaded) const SizedBox(width: 8),
                  Expanded(child: _buildActionButton('Limpar', AppColors.primaryYellow, _clearForm, textColor: Colors.black)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildActionButton('Salvar', AppColors.primaryGreen, _onSavePressed)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- MÉTODOS DE CONSTRUÇÃO DE UI VERTICAL ---
  Widget _buildVerticalTextField(String label, TextEditingController controller, bool isLocked, VoidCallback onUnlock, {int? maxLength, TextInputType? keyboardType, List<TextInputFormatter>? customFormatters}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: TextField(controller: controller, maxLength: maxLength, readOnly: isLocked, keyboardType: keyboardType, inputFormatters: customFormatters, textAlign: TextAlign.center, decoration: _inputDecoration(null))), if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock)]),
        ],
      ),
    );
  }

  Widget _buildVerticalDropdown(String label, List<String> options, String? selectedValue, bool isLocked, VoidCallback onUnlock, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: IgnorePointer(ignoring: isLocked, child: DropdownButtonFormField<String>(value: selectedValue, items: options.map((e) => DropdownMenuItem(value: e, alignment: AlignmentDirectional.center, child: Text(e))).toList(), onChanged: onChanged, decoration: _inputDecoration(null).copyWith(fillColor: isLocked ? Colors.grey.shade100 : Colors.white)))), if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock)]),
        ],
      ),
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

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed, {Color textColor = Colors.white}) => SizedBox(height: 48, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: onPressed, child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13))));
}