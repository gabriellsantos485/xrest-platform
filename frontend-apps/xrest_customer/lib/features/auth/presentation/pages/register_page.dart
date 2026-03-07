/*
 * File: register_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Comprehensive registration UI with input masks, regex email validation,
 * fragmented address fields, and cross-field password confirmation.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../state/auth_bloc.dart';
import '../state/auth_event.dart';
import '../state/auth_state.dart';
import '../../domain/entities/client_entity.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Formatters
  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _phoneFormatter = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _cepFormatter = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  // State for toggles
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Core Data
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // Fragmented Address Data
  final _cepCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _neighborhoodCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _complementCtrl = TextEditingController();

  // Security Data
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _cpfCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _cepCtrl.dispose();
    _streetCtrl.dispose();
    _numberCtrl.dispose();
    _neighborhoodCtrl.dispose();
    _cityCtrl.dispose();
    _complementCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      // Constructs a single address string to match the current ClientEntity contract.
      // In a later refactoring, the Entity itself should be updated to hold fragmented address objects.
      final fullAddress = '${_streetCtrl.text}, ${_numberCtrl.text} - ${_complementCtrl.text} - ${_neighborhoodCtrl.text}, ${_cityCtrl.text}. CEP: ${_cepCtrl.text}';

      final newClient = ClientEntity(
        id: 'temp_id_123',
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        cpf: _cpfCtrl.text.trim(), // Consider stripping mask characters before sending to API
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        address: fullAddress,
      );

      context.read<AuthBloc>().add(
        RegisterClientEvent(newClient: newClient, password: _passwordCtrl.text),
      );
    }
  }

  /// Evaluates standard email formatting using Regex
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Digite um e-mail válido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFF8C00)),
        title: const Text('CRIAR CONTA', style: TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cadastro realizado com sucesso!'), backgroundColor: Colors.green));
            Navigator.pop(context);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFFFF8C00)));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Dados Pessoais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const Divider(),
                  const SizedBox(height: 16),

                  _buildTextField(controller: _firstNameCtrl, label: 'Nome', icon: Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _lastNameCtrl, label: 'Sobrenome', icon: Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _cpfCtrl, label: 'CPF', icon: Icons.badge, keyboardType: TextInputType.number, formatter: _cpfFormatter),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _phoneCtrl, label: 'Telefone', icon: Icons.phone, keyboardType: TextInputType.phone, formatter: _phoneFormatter),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _emailCtrl, label: 'E-mail', icon: Icons.email, keyboardType: TextInputType.emailAddress, validator: _validateEmail),

                  const SizedBox(height: 32),
                  const Text('Endereço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const Divider(),
                  const SizedBox(height: 16),

                  _buildTextField(controller: _cepCtrl, label: 'CEP', icon: Icons.map, keyboardType: TextInputType.number, formatter: _cepFormatter),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(flex: 3, child: _buildTextField(controller: _streetCtrl, label: 'Rua', icon: Icons.signpost)),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: _buildTextField(controller: _numberCtrl, label: 'Nº', icon: Icons.numbers, keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _complementCtrl, label: 'Complemento', icon: Icons.add_business, isRequired: false),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(controller: _neighborhoodCtrl, label: 'Bairro', icon: Icons.holiday_village)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField(controller: _cityCtrl, label: 'Cidade', icon: Icons.location_city)),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Text('Segurança', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const Divider(),
                  const SizedBox(height: 16),

                  _buildPasswordField(
                      controller: _passwordCtrl,
                      label: 'Senha',
                      obscureText: _obscurePassword,
                      onToggle: () => setState(() => _obscurePassword = !_obscurePassword)
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                      controller: _confirmPasswordCtrl,
                      label: 'Confirmar Senha',
                      obscureText: _obscureConfirmPassword,
                      onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Campo obrigatório';
                        if (val != _passwordCtrl.text) return 'As senhas não coincidem';
                        return null;
                      }
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8C00),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: _submitRegistration,
                      child: const Text('Cadastrar', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = true,
    TextInputType keyboardType = TextInputType.text,
    MaskTextInputFormatter? formatter,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatter != null ? [formatter] : [],
      validator: validator ?? (value) {
        if (isRequired && (value == null || value.isEmpty)) return 'Obrigatório';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFF8C00)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator ?? (value) => value == null || value.isEmpty || value.length < 6 ? 'Mínimo de 6 caracteres' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Color(0xFFFF8C00)),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}