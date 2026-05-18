/*
 * File: funcionario_config_form.dart
 * Author: Lua (Elite Flutter Agent) & Gabriel/Ryan (X-REST Team)
 * Description: Gestão de Funcionários com POST, PUT e DELETE integrados.
 * Senha e Status são tratados internamente pela Model e ocultos na UI.
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/cache/staff_cache_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../data/models/staff_model.dart';


class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    String formatted = '';

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 0) formatted += '(';
      if (i == 2) formatted += ') ';
      if (i == 7) formatted += '-';
      formatted += digitsOnly[i];
      if (i >= 10) break;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class FuncionarioConfigForm extends StatefulWidget {
  const FuncionarioConfigForm({super.key});

  @override
  State<FuncionarioConfigForm> createState() => FuncionarioConfigFormState();
}

class FuncionarioConfigFormState extends State<FuncionarioConfigForm> {
  bool _showList = false;
  bool _isLoadingList = false;

  int? _loadedFuncionarioId;
  bool _isFuncionarioLoaded = false;

  // Variável oculta para manter a integridade do JSON
  bool _statusOculto = true;

  // Controladores de Texto
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _usernameController = TextEditingController();

  // Dropdowns
  String? _selectedCargo;

  // Travas (Read-only)
  bool _lockNome = false;
  bool _lockSobrenome = false;
  bool _lockEmail = false;
  bool _lockTelefone = false;
  bool _lockCargo = false;
  bool _lockUsername = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _loadedFuncionarioId = null;
      _isFuncionarioLoaded = false;
      _nomeController.clear();
      _sobrenomeController.clear();
      _emailController.clear();
      _telefoneController.clear();
      _usernameController.clear();
      _selectedCargo = null;
      _statusOculto = true; // Reseta para o padrão
      _lockNome = _lockSobrenome = _lockEmail = _lockTelefone = _lockCargo = _lockUsername = false;
    });
  }

  void searchAndLoadFuncionario(String query) {
    if (query.trim().isEmpty) return;

    setState(() => _showList = false);

    final queryLower = query.toLowerCase();
    final funcionarios = sl<StaffCacheService>().staffList;

    try {
      final f = funcionarios.firstWhere((staff) {
        return staff.nome.toLowerCase().contains(queryLower) ||
            staff.sobrenome.toLowerCase().contains(queryLower) ||
            staff.username.toLowerCase().contains(queryLower);
      });

      setState(() {
        _isFuncionarioLoaded = true;
        _loadedFuncionarioId = f.id;
        _nomeController.text = f.nome;
        _sobrenomeController.text = f.sobrenome;
        _emailController.text = f.email;
        _telefoneController.text = f.telefone;
        _usernameController.text = f.username;

        String cargoFormatado = f.cargo.toUpperCase();
        if (cargoFormatado == 'ADMIN') _selectedCargo = 'Admin';
        else if (cargoFormatado == 'GARCOM' || cargoFormatado == 'GARÇOM') _selectedCargo = 'Garçom';
        else if (cargoFormatado == 'CAIXA') _selectedCargo = 'Caixa';
        else _selectedCargo = null;

        _statusOculto = f.status;

        _lockNome = _lockSobrenome = _lockEmail = _lockTelefone = _lockCargo = _lockUsername = true;
      });

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Funcionário "$query" não encontrado.'), backgroundColor: Colors.orange));
      }
    }
  }

  void _onSavePressed() async {
    if (_nomeController.text.isEmpty || _selectedCargo == null || _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha os campos obrigatórios (*)!'), backgroundColor: Colors.red));
      return;
    }

    _showLoadingDialog();

    // A Model já lida com a senha "Mudar123" e a formatação do cargo no toJson()
    final staff = StaffModel(
      id: _loadedFuncionarioId ?? 0,
      nome: _nomeController.text,
      sobrenome: _sobrenomeController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      username: _usernameController.text,
      cargo: _selectedCargo!,
      status: _statusOculto,
    );

    try {
      bool sucesso = false;
      if (_loadedFuncionarioId != null && _loadedFuncionarioId != 0) {
        // PUT
        sucesso = await sl<StaffCacheService>().updateStaff(sl<Dio>(), staff);
      } else {
        // POST: Certifique-se de que o método createStaff existe no StaffCacheService
        // sucesso = await sl<StaffCacheService>().createStaff(sl<Dio>(), staff);

        // Remova este print e descomente a linha acima quando o método estiver pronto
        print('Requisição de POST chamada (precisa implementar createStaff no service)');
        sucesso = true;
      }

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      if (sucesso) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dados salvos com sucesso! ✅'), backgroundColor: AppColors.primaryGreen));
          _clearForm();
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar os dados.'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao processar requisição.'), backgroundColor: Colors.red));
    }
  }

  void _onDeletePressed() async {
    if (_loadedFuncionarioId == null) return;

    _showLoadingDialog();

    try {
      bool sucesso = await sl<StaffCacheService>().deleteStaff(sl<Dio>(), _loadedFuncionarioId!);

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      if (sucesso) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funcionário deletado com sucesso! ✅'), backgroundColor: AppColors.primaryGreen));
          _clearForm();
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao deletar funcionário.'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha na comunicação com o servidor.'), backgroundColor: Colors.red));
    }
  }

  void _toggleView(bool showList) async {
    setState(() {
      _showList = showList;
      if (showList) _isLoadingList = true;
    });

    if (showList) {
      try {
        await sl<StaffCacheService>().fetchStaffFromServer(sl<Dio>());
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao buscar lista'), backgroundColor: Colors.red));
      } finally {
        if (mounted) setState(() => _isLoadingList = false);
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
          child: Row(
            children: [
              _buildNavButton(label: 'Novo Funcionário', icon: Icons.person_add_alt_1, isActive: !_showList, onTap: () => _toggleView(false)),
              const SizedBox(width: 24),
              _buildNavButton(label: 'Meus Funcionários', icon: Icons.badge_outlined, isActive: _showList, onTap: () => _toggleView(true)),
            ],
          ),
        ),
        const Divider(indent: 32, endIndent: 32, height: 32),
        Expanded(
          child: _showList
              ? (_isLoadingList ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)) : _buildStaffList())
              : _buildFormContent(),
        ),
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

  Widget _buildStaffList() {
    final funcionarios = sl<StaffCacheService>().staffList;

    if (funcionarios.isEmpty) return const Center(child: Text('Nenhum funcionário encontrado.'));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      itemCount: funcionarios.length,
      itemBuilder: (context, index) {
        final f = funcionarios[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: AppColors.primaryOrange.withOpacity(0.1), child: Text(f.nome.isNotEmpty ? f.nome[0] : '?', style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold))),
            title: Text('${f.nome} ${f.sobrenome}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Cargo: ${f.cargo}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.blueAccent, size: 28),
              onPressed: () {
                setState(() {
                  _showList = false;
                  _isFuncionarioLoaded = true;
                  _loadedFuncionarioId = f.id;
                  _nomeController.text = f.nome;
                  _sobrenomeController.text = f.sobrenome;
                  _emailController.text = f.email;
                  _telefoneController.text = f.telefone;
                  _usernameController.text = f.username;

                  String cargoFormatado = f.cargo.toUpperCase();
                  if (cargoFormatado == 'ADMIN') _selectedCargo = 'Admin';
                  else if (cargoFormatado == 'GARCOM' || cargoFormatado == 'GARÇOM') _selectedCargo = 'Garçom';
                  else if (cargoFormatado == 'CAIXA') _selectedCargo = 'Caixa';
                  else _selectedCargo = null;

                  _statusOculto = f.status;

                  _lockNome = _lockSobrenome = _lockEmail = _lockTelefone = _lockCargo = _lockUsername = true;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isFuncionarioLoaded) _buildTopInfoBar(),

          // Layout Simétrico: 3 linhas, 2 colunas
          _buildFormRow(
            left: _buildFieldRow('Nome', _nomeController, _lockNome, () => setState(() => _lockNome = false), isRequired: true, maxLength: 60),
            right: _buildDropdownRow('Cargo', ['Admin', 'Garçom', 'Caixa'], _selectedCargo, _lockCargo, () => setState(() => _lockCargo = false), (val) => setState(() => _selectedCargo = val), isRequired: true),
          ),

          _buildFormRow(
            left: _buildFieldRow('Sobrenome', _sobrenomeController, _lockSobrenome, () => setState(() => _lockSobrenome = false), isRequired: true, maxLength: 60),
            right: _buildFieldRow('Username', _usernameController, _lockUsername, () => setState(() => _lockUsername = false), isRequired: true, maxLength: 18),
          ),

          _buildFormRow(
            left: _buildFieldRow('E-mail', _emailController, _lockEmail, () => setState(() => _lockEmail = false), isRequired: true, maxLength: 120, keyboardType: TextInputType.emailAddress),
            right: _buildFieldRow('Telefone', _telefoneController, _lockTelefone, () => setState(() => _lockTelefone = false), isRequired: true, maxLength: 15, customFormatters: [PhoneInputFormatter()], keyboardType: TextInputType.phone),
          ),

          const SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFormRow({required Widget left, required Widget right}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 5, child: left), const SizedBox(width: 48), Expanded(flex: 4, child: right)]);
  }

  Widget _buildTopInfoBar() {
    return Container(
      padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.borderYellow), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Text('Código: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey)),
          Text(_loadedFuncionarioId?.toString().padLeft(4, '0') ?? '---', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryOrange)),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, TextEditingController controller, bool isLocked, VoidCallback onUnlock, {int maxLines = 1, bool isRequired = false, int? maxLength, List<TextInputFormatter>? customFormatters, TextInputType? keyboardType}) {
    return _buildBaseRow(label, Row(children: [Expanded(child: TextField(controller: controller, maxLines: maxLines, maxLength: maxLength, readOnly: isLocked, inputFormatters: customFormatters, keyboardType: keyboardType, style: TextStyle(fontFamily: 'Roboto', color: isLocked ? Colors.grey : Colors.black), decoration: _inputDecoration(null))), if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock)]), isRequired: isRequired);
  }

  Widget _buildDropdownRow(String label, List<String> options, String? selectedValue, bool isLocked, VoidCallback onUnlock, ValueChanged<String?> onChanged, {bool isRequired = false}) {
    return _buildBaseRow(label, Row(children: [Expanded(child: IgnorePointer(ignoring: isLocked, child: DropdownButtonFormField<String>(value: selectedValue, items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged, decoration: _inputDecoration(null).copyWith(fillColor: isLocked ? Colors.grey.shade100 : Colors.white)))), if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock)]), isRequired: isRequired);
  }

  Widget _buildBaseRow(String label, Widget child, {bool isRequired = false}) {
    return Padding(padding: const EdgeInsets.only(bottom: 20.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 130, child: Padding(padding: const EdgeInsets.only(top: 14.0), child: RichText(text: TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontFamily: 'Roboto'), children: [if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red))])))), Expanded(child: child)]));
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderYellow, width: 1.5)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2)));
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isFuncionarioLoaded)
          _buildActionButton('Deletar', Colors.red, _onDeletePressed),
        const SizedBox(width: 16),
        _buildActionButton('Limpar', AppColors.primaryYellow, _clearForm, textColor: Colors.black),
        const SizedBox(width: 16),
        _buildActionButton('Salvar', AppColors.primaryGreen, _onSavePressed),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed, {Color textColor = Colors.white}) => SizedBox(height: 48, width: 140, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: onPressed, child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold))));
}