import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cache/global_cache_manager.dart';
import '../../../../core/constants/app_strings.dart';

import '../../../../core/presentation/widgets/main_shell_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers para capturar os dados inseridos pelo utilizador
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Estados para controlar o Overlay de Sincronização
  bool _isSyncing = false;
  bool _hasSyncError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Lógica de "Warm-up" dos dados após o login
  Future<void> _handlePostLoginSync() async {
    setState(() {
      _isSyncing = true;
      _hasSyncError = false;
    });

    // O GlobalCacheManager coordena todas as requisições
    final success = await sl<GlobalCacheManager>().initializeAppData();

    if (success) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainShellPage()),
        );
      }
    } else {
      // Se falhar (ex: sem internet), mostra o erro no modal
      setState(() => _hasSyncError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camada 1: Interface principal de Login
          _buildMainLoginUI(),

          // Camada 2: Overlay de Sincronização (aparece apenas quando _isSyncing for true)
          if (_isSyncing) _buildSyncOverlay(),
        ],
      ),
    );
  }

  // --- ESTRUTURA ORIGINAL DE UI SEPARADA EM UM MÉTODO ---
  Widget _buildMainLoginUI() {
    return Row(
      children: [
        // Painel Esquerdo: Branding e Slogan com Imagem de Fundo
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              image: DecorationImage(
                image: const AssetImage('assets/images/login_bg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.75),
                  BlendMode.darken,
                ),
              ),
            ),
            child: _buildLeftContent(),
          ),
        ),

        // Painel Direito: Formulário de Autenticação
        Expanded(
          flex: 6,
          child: Container(
            color: AppColors.backgroundLight,
            child: _buildRightContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: AppColors.primaryYellow,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  AppStrings.loginSlogan,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRightContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.1,
            vertical: 40,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppStrings.welcomeBack,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.systemSubtitle,
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 64),

                _buildTextField(label: AppStrings.emailLabel, hint: AppStrings.emailHint, controller: _emailController),
                const SizedBox(height: 24),
                _buildTextField(label: AppStrings.passwordLabel, hint: AppStrings.passwordHint, obscureText: true, controller: _passwordController),
                const SizedBox(height: 48),

                // Botão e BLoC Listener
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      // Ao invés de navegar ou rodar cache cru, chama o maestro de sincronização
                      _handlePostLoginSync();
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                      );
                    }
                  },
                  builder: (context, state) {
                    // Previne duplicação de spinners (deixa o overlay assumir o carregamento)
                    if (state is AuthLoading && !_isSyncing) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          // Impede cliques se já estiver a sincronizar
                          if (!_isSyncing) {
                            context.read<AuthBloc>().add(
                              LoginRequested(email: _emailController.text, password: _passwordController.text),
                            );
                          }
                        },
                        child: const Text(
                          AppStrings.loginButton,
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    AppStrings.forgotPassword,
                    style: TextStyle(color: AppColors.linkBlue, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({required String label, required String hint, required TextEditingController controller, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontFamily: 'Roboto'),
      decoration: InputDecoration(
        labelText: label, hintText: hint, floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(color: AppColors.primaryOrange, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderYellow, width: 2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2)),
      ),
    );
  }

  // --- COMPONENTES DO OVERLAY DE SINCRONIZAÇÃO ---
  Widget _buildSyncOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.7), // Fundo escurecido
      child: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderYellow, width: 2),
          ),
          child: _hasSyncError ? _buildErrorContent() : _buildLoadingContent(),
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(
          height: 80,
          width: 80,
          child: CircularProgressIndicator(
            color: AppColors.primaryOrange,
            strokeWidth: 6, // Círculo mais expesso conforme solicitado
          ),
        ),
        SizedBox(height: 32),
        Text('Sincronizando Dados', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: 'Roboto')),
        SizedBox(height: 8),
        Text('Aguarde um momento...', style: TextStyle(color: Colors.grey, fontFamily: 'Roboto')),
      ],
    );
  }

  Widget _buildErrorContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('☹️', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        const Text(
          'Tivemos um problema,\ntente novamente mais tarde!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: 'Roboto'),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: _handlePostLoginSync, // Tenta sincronizar novamente sem refazer login
          child: const Text('Tentar Novamente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() {
            _isSyncing = false; // Fecha o modal e volta para a tela de login vazia
          }),
          child: const Text('Voltar ao Login', style: TextStyle(color: Colors.grey, fontFamily: 'Roboto')),
        )
      ],
    );
  }
}