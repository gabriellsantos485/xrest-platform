/*
 * File: cliente_config_form.dart
 * Author: X-REST Team
 * Description: Gestão de Clientes integrada ao ClienteCacheService (CRUD completo).
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/cache/cliente_cache_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../data/models/cliente_model.dart';


// --- FORMATADORES DE MÁSCARA ---

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
      if (i >= 11) break;
    }
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 3 || i == 6) formatted += '.';
      if (i == 9) formatted += '-';
      formatted += digitsOnly[i];
      if (i >= 11) break;
    }
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 5) formatted += '-';
      formatted += digitsOnly[i];
      if (i >= 8) break;
    }
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

// --- TELA PRINCIPAL ---

class ClienteConfigForm extends StatefulWidget {
  const ClienteConfigForm({super.key});

  @override
  State<ClienteConfigForm> createState() => ClienteConfigFormState();
}

class ClienteConfigFormState extends State<ClienteConfigForm> {
  bool _showList = false;
  bool _isLoadingList = false;

  int? _loadedClienteId;
  bool _isClienteLoaded = false;

  // Controladores de Texto
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _cidadeController = TextEditingController();

  // Travas (Read-only)
  bool _lockNome = false; bool _lockSobrenome = false; bool _lockEmail = false;
  bool _lockCpf = false; bool _lockTelefone = false;
  bool _lockCep = false; bool _lockRua = false; bool _lockBairro = false;
  bool _lockNumero = false; bool _lockCidade = false;

  @override
  void dispose() {
    _nomeController.dispose(); _sobrenomeController.dispose(); _emailController.dispose();
    _cpfController.dispose(); _telefoneController.dispose(); _cepController.dispose();
    _ruaController.dispose(); _bairroController.dispose(); _numeroController.dispose(); _cidadeController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _loadedClienteId = null;
      _isClienteLoaded = false;
      _nomeController.clear(); _sobrenomeController.clear(); _emailController.clear();
      _cpfController.clear(); _telefoneController.clear(); _cepController.clear();
      _ruaController.clear(); _bairroController.clear(); _numeroController.clear(); _cidadeController.clear();
      _lockNome = _lockSobrenome = _lockEmail = _lockCpf = _lockTelefone = false;
      _lockCep = _lockRua = _lockBairro = _lockNumero = _lockCidade = false;
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
    );
  }

  void _onSavePressed() async {
    if (_nomeController.text.isEmpty || _cpfController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nome e CPF são obrigatórios!'), backgroundColor: Colors.red));
      return;
    }

    _showLoadingDialog();

    final cliente = ClienteModel(
      id: _loadedClienteId ?? 0,
      nome: _nomeController.text,
      sobrenome: _sobrenomeController.text,
      cpf: _cpfController.text,
      telefone: _telefoneController.text,
      email: _emailController.text,
      cep: _cepController.text,
      rua: _ruaController.text,
      bairro: _bairroController.text,
      numero: _numeroController.text,
      cidade: _cidadeController.text,
    );

    try {
      bool sucesso;
      if (_loadedClienteId != null && _loadedClienteId != 0) {
        sucesso = await sl<ClienteCacheService>().updateClient(sl<Dio>(), cliente);
      } else {
        sucesso = await sl<ClienteCacheService>().createClient(sl<Dio>(), cliente);
      }

      if (mounted) Navigator.of(context, rootNavigator: true).pop(); // Fecha Loader

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente salvo com sucesso! ✅'), backgroundColor: AppColors.primaryGreen));
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar cliente.'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha na comunicação com o servidor.'), backgroundColor: Colors.red));
    }
  }

  void _onDeletePressed() async {
    if (_loadedClienteId == null) return;

    _showLoadingDialog();

    try {
      bool sucesso = await sl<ClienteCacheService>().deleteClient(sl<Dio>(), _loadedClienteId!);

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente deletado com sucesso! ✅'), backgroundColor: AppColors.primaryGreen));
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao deletar cliente.'), backgroundColor: Colors.red));
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
        await sl<ClienteCacheService>().fetchClientsFromServer(sl<Dio>());
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao buscar lista de clientes'), backgroundColor: Colors.red));
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
              _buildNavButton(label: 'Novo Cliente', icon: Icons.person_add_alt_1, isActive: !_showList, onTap: () => _toggleView(false)),
              const SizedBox(width: 24),
              _buildNavButton(label: 'Meus Clientes', icon: Icons.people_alt_outlined, isActive: _showList, onTap: () => _toggleView(true)),
            ],
          ),
        ),
        const Divider(indent: 32, endIndent: 32, height: 32),
        Expanded(
          child: _showList
              ? (_isLoadingList ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)) : _buildClientList())
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

  Widget _buildClientList() {
    final clientes = sl<ClienteCacheService>().clienteList;

    if (clientes.isEmpty) return const Center(child: Text('Nenhum cliente encontrado.'));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      itemCount: clientes.length,
      itemBuilder: (context, index) {
        final c = clientes[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: AppColors.primaryOrange.withOpacity(0.1), child: Text(c.nome.isNotEmpty ? c.nome[0] : '?', style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold))),
            title: Text('${c.nome} ${c.sobrenome}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('CPF: ${c.cpf} • Tel: ${c.telefone}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.blueAccent, size: 28),
              onPressed: () {
                setState(() {
                  _showList = false;
                  _isClienteLoaded = true;
                  _loadedClienteId = c.id;
                  _nomeController.text = c.nome; _sobrenomeController.text = c.sobrenome;
                  _emailController.text = c.email; _cpfController.text = c.cpf;
                  _telefoneController.text = c.telefone; _cepController.text = c.cep;
                  _ruaController.text = c.rua; _bairroController.text = c.bairro;
                  _numeroController.text = c.numero; _cidadeController.text = c.cidade;

                  _lockNome = _lockSobrenome = _lockEmail = _lockCpf = _lockTelefone = true;
                  _lockCep = _lockRua = _lockBairro = _lockNumero = _lockCidade = true;
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
          if (_isClienteLoaded) _buildTopInfoBar(),

          _buildFormRow(
            left: _buildFieldRow('Nome', _nomeController, _lockNome, () => setState(() => _lockNome = false), isRequired: true, maxLength: 60),
            right: _buildFieldRow('CPF', _cpfController, _lockCpf, () => setState(() => _lockCpf = false), isRequired: true, maxLength: 14, customFormatters: [CpfInputFormatter()], keyboardType: TextInputType.number),
          ),
          _buildFormRow(
            left: _buildFieldRow('Sobrenome', _sobrenomeController, _lockSobrenome, () => setState(() => _lockSobrenome = false), isRequired: true, maxLength: 60),
            right: _buildFieldRow('Telefone', _telefoneController, _lockTelefone, () => setState(() => _lockTelefone = false), isRequired: true, maxLength: 15, customFormatters: [PhoneInputFormatter()], keyboardType: TextInputType.phone),
          ),
          _buildFormRow(
            left: _buildFieldRow('Email', _emailController, _lockEmail, () => setState(() => _lockEmail = false), maxLength: 120, keyboardType: TextInputType.emailAddress),
            right: const SizedBox(),
          ),

          const SizedBox(height: 16),
          const Text('Dados de Endereço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const Divider(color: AppColors.borderYellow, thickness: 1),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildCompactFieldRow('CEP', _cepController, _lockCep, () => setState(() => _lockCep = false), maxLength: 9, customFormatters: [CepInputFormatter()], keyboardType: TextInputType.number)),
              const SizedBox(width: 24),
              Expanded(flex: 5, child: _buildCompactFieldRow('Rua', _ruaController, _lockRua, () => setState(() => _lockRua = false), maxLength: 100)),
              const SizedBox(width: 24),
              Expanded(flex: 4, child: _buildCompactFieldRow('Bairro', _bairroController, _lockBairro, () => setState(() => _lockBairro = false), maxLength: 60)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildCompactFieldRow('Número', _numeroController, _lockNumero, () => setState(() => _lockNumero = false), maxLength: 10)),
              const SizedBox(width: 24),
              Expanded(flex: 5, child: _buildCompactFieldRow('Cidade', _cidadeController, _lockCidade, () => setState(() => _lockCidade = false), maxLength: 60)),
              const SizedBox(width: 24),
              Expanded(flex: 4, child: const SizedBox()),
            ],
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
          Text(_loadedClienteId?.toString().padLeft(4, '0') ?? '---', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryOrange)),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, TextEditingController controller, bool isLocked, VoidCallback onUnlock, {int maxLines = 1, bool isRequired = false, int? maxLength, List<TextInputFormatter>? customFormatters, TextInputType? keyboardType}) {
    return _buildBaseRow(label, 130, Row(children: [Expanded(child: TextField(controller: controller, maxLines: maxLines, maxLength: maxLength, readOnly: isLocked, inputFormatters: customFormatters, keyboardType: keyboardType, style: TextStyle(fontFamily: 'Roboto', color: isLocked ? Colors.grey : Colors.black), decoration: _inputDecoration(null))), if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock)]), isRequired: isRequired);
  }

  Widget _buildCompactFieldRow(String label, TextEditingController controller, bool isLocked, VoidCallback onUnlock, {int maxLines = 1, bool isRequired = false, int? maxLength, List<TextInputFormatter>? customFormatters, TextInputType? keyboardType}) {
    return _buildBaseRow(label, 65, Row(children: [Expanded(child: TextField(controller: controller, maxLines: maxLines, maxLength: maxLength, readOnly: isLocked, inputFormatters: customFormatters, keyboardType: keyboardType, style: TextStyle(fontFamily: 'Roboto', color: isLocked ? Colors.grey : Colors.black), decoration: _inputDecoration(null))), if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock)]), isRequired: isRequired);
  }

  Widget _buildBaseRow(String label, double labelWidth, Widget child, {bool isRequired = false}) {
    return Padding(padding: const EdgeInsets.only(bottom: 20.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: labelWidth, child: Padding(padding: const EdgeInsets.only(top: 14.0), child: RichText(text: TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontFamily: 'Roboto'), children: [if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red))])))), Expanded(child: child)]));
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isClienteLoaded)
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