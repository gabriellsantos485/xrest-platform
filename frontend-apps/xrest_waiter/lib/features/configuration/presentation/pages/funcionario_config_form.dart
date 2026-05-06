import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

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
      if (i >= 10) break; // Limita a 11 dígitos numéricos
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
  int? _loadedFuncionarioId;
  bool _isFuncionarioLoaded = false;

  // Controladores de Texto
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _senhaController = TextEditingController();

  // Dropdowns
  String? _selectedCargo;
  String? _selectedStatus = 'Ativo';

  // Travas (Read-only)
  bool _lockNome = false;
  bool _lockSobrenome = false;
  bool _lockEmail = false;
  bool _lockTelefone = false;
  bool _lockCargo = false;
  bool _lockStatus = false;
  bool _lockUsername = false;
  bool _lockSenha = false;

  // Visibilidade da Senha
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _usernameController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void searchAndLoadFuncionario(String query) {
    if (query.trim().isEmpty) return;
    print('Pesquisando funcionário por: $query');
    // TODO: Implementar busca no StaffCacheService
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
      _senhaController.clear();

      _selectedCargo = null;
      _selectedStatus = 'Ativo';

      _lockNome = _lockSobrenome = _lockEmail = _lockTelefone =
          _lockCargo = _lockStatus = _lockUsername = _lockSenha = false;
      _isPasswordVisible = false;
    });
  }

  void _onSavePressed() {
    if (_nomeController.text.isEmpty || _sobrenomeController.text.isEmpty ||
        _emailController.text.isEmpty || _telefoneController.text.isEmpty ||
        _usernameController.text.isEmpty || _senhaController.text.isEmpty || _selectedCargo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatórios (*)!'), backgroundColor: Colors.red),
      );
      return;
    }
    // TODO: Implementar POST/PUT via StaffCacheService
    print('Salvar funcionário clicado!');
  }

  void _onDeletePressed() {
    // TODO: Implementar SOFT DELETE via StaffCacheService
    print('Inativar funcionário clicado!');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isFuncionarioLoaded) _buildTopInfoBar(),

          _buildFormRow(
            left: _buildFieldRow('Nome', _nomeController, _lockNome, () => setState(() => _lockNome = false), isRequired: true, maxLength: 60),
            right: _buildDropdownRow('Cargo', ['Cozinheiro', 'Admin', 'Garçom'], _selectedCargo, _lockCargo, () => setState(() => _lockCargo = false), (val) => setState(() => _selectedCargo = val), isRequired: true),
          ),

          _buildFormRow(
            left: _buildFieldRow('Sobrenome', _sobrenomeController, _lockSobrenome, () => setState(() => _lockSobrenome = false), isRequired: true, maxLength: 60),
            right: _buildFieldRow('Username', _usernameController, _lockUsername, () => setState(() => _lockUsername = false), isRequired: true, maxLength: 18),
          ),

          _buildFormRow(
            left: _buildFieldRow('E-mail', _emailController, _lockEmail, () => setState(() => _lockEmail = false), isRequired: true, maxLength: 120, keyboardType: TextInputType.emailAddress),
            right: _buildPasswordField(),
          ),

          _buildFormRow(
            left: _buildFieldRow('Telefone', _telefoneController, _lockTelefone, () => setState(() => _lockTelefone = false), isRequired: true, maxLength: 15, customFormatters: [PhoneInputFormatter()], keyboardType: TextInputType.phone),
            right: _buildDropdownRow('Status', ['Ativo', 'Inativo'], _selectedStatus, _lockStatus, () => setState(() => _lockStatus = false), (val) => setState(() => _selectedStatus = val), isRequired: true),
          ),

          const SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // Novo método que garante o alinhamento horizontal das duas colunas
  Widget _buildFormRow({required Widget left, required Widget right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinha pelo topo de cada linha
      children: [
        Expanded(flex: 5, child: left),
        const SizedBox(width: 48), // Espaçamento central igual ao cardápio
        Expanded(flex: 4, child: right),
      ],
    );
  }

  Widget _buildTopInfoBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.borderYellow), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Text('Código: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey)),
          Text(
            _loadedFuncionarioId?.toString().padLeft(4, '0') ?? '---',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryOrange),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, TextEditingController controller, bool isLocked, VoidCallback onUnlock, {int maxLines = 1, bool isRequired = false, int? maxLength, List<TextInputFormatter>? customFormatters, TextInputType? keyboardType}) {
    return _buildBaseRow(label, Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            readOnly: isLocked,
            inputFormatters: customFormatters,
            keyboardType: keyboardType,
            style: TextStyle(fontFamily: 'Roboto', color: isLocked ? Colors.grey : Colors.black),
            decoration: _inputDecoration(null),
          ),
        ),
        if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock),
      ],
    ), isRequired: isRequired);
  }

  Widget _buildPasswordField() {
    return _buildBaseRow('Senha', Row(
      children: [
        Expanded(
          child: TextField(
            controller: _senhaController,
            obscureText: !_isPasswordVisible,
            readOnly: _lockSenha,
            maxLength: 50, // Adicionado um limite apenas para nivelar visualmente, ou pode remover o maxLength se preferir
            style: TextStyle(fontFamily: 'Roboto', color: _lockSenha ? Colors.grey : Colors.black),
            decoration: _inputDecoration(null).copyWith(
              counterText: "", // Esconde o contador para não poluir
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
          ),
        ),
        if (_lockSenha) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: () => setState(() => _lockSenha = false)),
      ],
    ), isRequired: true);
  }

  Widget _buildDropdownRow(String label, List<String> options, String? selectedValue, bool isLocked, VoidCallback onUnlock, ValueChanged<String?> onChanged, {bool isRequired = false}) {
    return _buildBaseRow(label, Row(
      children: [
        Expanded(
          child: IgnorePointer(
            ignoring: isLocked,
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
              decoration: _inputDecoration(null).copyWith(fillColor: isLocked ? Colors.grey.shade100 : Colors.white),
            ),
          ),
        ),
        if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock),
      ],
    ), isRequired: isRequired);
  }

  Widget _buildBaseRow(String label, Widget child, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0), // Margem inferior de cada linha
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 130,
              child: Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: RichText(
                      text: TextSpan(
                          text: label,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontFamily: 'Roboto'),
                          children: [if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                      )
                  )
              )
          ),
          Expanded(child: child),
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
    );
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