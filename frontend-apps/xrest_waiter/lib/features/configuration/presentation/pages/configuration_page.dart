import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'cardapio_config_form.dart';
import 'funcionario_config_form.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> with TickerProviderStateMixin {
  late TabController _tabController;

  // 1. Controlador para ler o texto digitado na pesquisa
  final TextEditingController _searchController = TextEditingController();

  // 2. AS PONTES: Chaves Globais para acessar as funções de busca de cada aba
  final GlobalKey<CardapioConfigFormState> _cardapioFormKey = GlobalKey<CardapioConfigFormState>();
  final GlobalKey<FuncionarioConfigFormState> _funcionarioFormKey = GlobalKey<FuncionarioConfigFormState>(); // <-- Nova chave

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // 3. Função disparada ao clicar no botão azul ou apertar ENTER
  void _executeSearch() {
    final query = _searchController.text;
    if (query.isEmpty) return;

    // Verifica qual aba está aberta atualmente e direciona a pesquisa
    if (_tabController.index == 0) {
      _cardapioFormKey.currentState?.searchAndLoadItem(query);
    } else if (_tabController.index == 2) {
      // Aba 2 = Funcionário. Dispara a busca no formulário de funcionário!
      _funcionarioFormKey.currentState?.searchAndLoadFuncionario(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra Superior de Pesquisa e Título
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              const Text(
                'CONFIGURAÇÕES',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryOrange, fontFamily: 'Roboto'),
              ),
              const Spacer(),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _executeSearch(),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryOrange),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: AppColors.borderYellow)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _executeSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Buscar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              ),
            ],
          ),
        ),

        // Tab Bar (Cabeçalhos das Abas)
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryOrange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryOrange,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Roboto'),
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: 'Cardápio'),
            Tab(icon: Icon(Icons.people), text: 'Cliente'),
            Tab(icon: Icon(Icons.badge), text: 'Funcionário'),
            Tab(icon: Icon(Icons.table_restaurant), text: 'Mesa'),
            Tab(icon: Icon(Icons.point_of_sale), text: 'Pagamento'),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              CardapioConfigForm(key: _cardapioFormKey),

              _buildConfigContent('Formulário de Cliente'),

              FuncionarioConfigForm(key: _funcionarioFormKey),

              _buildConfigContent('Formulário de Mesa'),
              _buildConfigContent('Formulário de Pagamento'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfigContent(String title) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(title, style: TextStyle(fontSize: 20, color: Colors.grey.shade400, fontFamily: 'Roboto')),
      ),
    );
  }
}