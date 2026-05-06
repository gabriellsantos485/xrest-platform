import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/cache/category_cache_service.dart';
import '../../../../core/cache/menu_cache_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../data/models/menu_item_model.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return newValue.copyWith(text: '');
    double value = double.parse(digitsOnly) / 100;
    String formatted = value.toStringAsFixed(2);
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CardapioConfigForm extends StatefulWidget {
  const CardapioConfigForm({super.key});

  @override
  State<CardapioConfigForm> createState() => CardapioConfigFormState();
}

class CardapioConfigFormState extends State<CardapioConfigForm> {
  int? _loadedItemId;
  bool _isItemLoaded = false;
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _precoController = TextEditingController();
  final _porcoesController = TextEditingController();
  final _imagemController = TextEditingController();

  String? _selectedCategoria;
  String? _selectedStatus = 'Ativo';
  String? _selectedUnidade = 'g';

  final _percentualDescontoController = TextEditingController();
  DateTime? _dataInicioPromo;
  DateTime? _dataFimPromo;

  bool _lockNome = false;
  bool _lockDescricao = false;
  bool _lockIngredientes = false;
  bool _lockPreco = false;
  bool _lockCategoria = false;
  bool _lockStatus = false;
  bool _lockUnidade = false;
  bool _lockPorcoes = false;

  List<String> _categoriasDisponiveveis = [];

  @override
  void initState() {
    super.initState();
    _carregarCategoriasDoCache();
  }

  void _carregarCategoriasDoCache() {
    setState(() {
      _categoriasDisponiveveis = sl<CategoryCacheService>().categoryNames;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _ingredientesController.dispose();
    _precoController.dispose();
    _porcoesController.dispose();
    _imagemController.dispose();
    _percentualDescontoController.dispose();
    super.dispose();
  }

  void searchAndLoadItem(String query) {
    if (query.trim().isEmpty) return;
    final results = sl<MenuCacheService>().searchItems(query);

    if (results.isNotEmpty) {
      final item = results.first;

      setState(() {
        _isItemLoaded = true;
        _loadedItemId = item.id;
        _nomeController.text = item.nome;
        _descricaoController.text = item.descricao ?? '';
        _ingredientesController.text = item.ingredientes ?? '';
        _precoController.text = item.valorUnidade.toStringAsFixed(2);

        _carregarCategoriasDoCache();
        _selectedCategoria = _categoriasDisponiveveis.contains(item.categoriaNome) ? item.categoriaNome : null;

        if (item.status.toUpperCase() == 'ATIVO') {
          _selectedStatus = 'Ativo';
        } else if (item.status.toUpperCase() == 'INATIVO') {
          _selectedStatus = 'Inativo';
        } else if (item.status.toUpperCase() == 'ESGOTADO'){
          _selectedStatus = 'Esgotado';
        } else if (item.status.toUpperCase() == 'BLOQUEADO'){
          _selectedStatus = 'Bloqueado';
        }
        else {
          _selectedStatus = null;
        }
        // ---------------------------

        _selectedUnidade = item.unidadeMedida.toLowerCase();
        _porcoesController.text = item.porcoesPorPessoa?.toString() ?? '';
        _imagemController.text = item.foto ?? '';

        if (item.valorPromocional != null && item.valorPromocional! > 0) {
          double percentual = ((item.valorUnidade - item.valorPromocional!) / item.valorUnidade) * 100;
          _percentualDescontoController.text = percentual.toStringAsFixed(0);
        } else {
          _percentualDescontoController.clear();
        }

        _dataInicioPromo = item.inicioPromocao;
        _dataFimPromo = item.terminoPromocao;

        _lockNome = _lockDescricao = _lockIngredientes = _lockPreco =
            _lockCategoria = _lockStatus = _lockUnidade = _lockPorcoes = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produto "$query" não encontrado.')));
    }
  }

  void _clearForm() {
    setState(() {
      _loadedItemId = null;
      _isItemLoaded = false;
      _nomeController.clear();
      _descricaoController.clear();
      _ingredientesController.clear();
      _precoController.clear();
      _porcoesController.clear();
      _imagemController.clear();
      _percentualDescontoController.clear();
      _selectedCategoria = null;
      _selectedStatus = 'Ativo';
      _selectedUnidade = 'g';
      _dataInicioPromo = _dataFimPromo = null;
      _lockNome = _lockDescricao = _lockIngredientes = _lockPreco =
          _lockCategoria = _lockStatus = _lockUnidade = _lockPorcoes = false;
    });
  }

  void _showManageCategoriesDialog() {
    final newCategoryController = TextEditingController();
    final editCategoryController = TextEditingController();
    int? editingCategoryId;
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setStateDialog) {
              // Busca os objetos completos (ID e Nome)
              final categorias = sl<CategoryCacheService>().categories;

              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.category, color: AppColors.primaryOrange),
                        SizedBox(width: 8),
                        Text('Gerenciar Categorias', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: isSaving ? null : () {
                        // Ao fechar, atualiza a lista do Dropdown no formulário principal
                        setState(() {
                          _carregarCategoriasDoCache();
                          // Se a categoria selecionada foi apagada, limpa o dropdown
                          if (_selectedCategoria != null && !_categoriasDisponiveveis.contains(_selectedCategoria)) {
                            _selectedCategoria = null;
                          }
                        });
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                content: SizedBox(
                  width: 450,
                  height: 500,
                  child: Column(
                    children: [
                      // --- BARRA DE CRIAR NOVA CATEGORIA ---
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: newCategoryController,
                              enabled: !isSaving,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintText: 'Nome da nova categoria...',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
                            onPressed: isSaving ? null : () async {
                              final name = newCategoryController.text.trim();
                              if (name.isNotEmpty) {
                                setStateDialog(() => isSaving = true);
                                final success = await sl<CategoryCacheService>().createCategory(sl<Dio>(), name);

                                setStateDialog(() {
                                  isSaving = false;
                                  if (success) newCategoryController.clear();
                                });

                                if (!success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar categoria.'), backgroundColor: Colors.red));
                                }
                              }
                            },
                            child: const Icon(Icons.add, color: Colors.white),
                          )
                        ],
                      ),
                      const Divider(height: 32, color: AppColors.borderYellow, thickness: 1),

                      // --- LISTA DE CATEGORIAS EXISTENTES ---
                      Expanded(
                        child: isSaving
                            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange))
                            : ListView.builder(
                          itemCount: categorias.length,
                          itemBuilder: (context, index) {
                            final cat = categorias[index];
                            final isEditing = editingCategoryId == cat.id;

                            return Card(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: isEditing
                                    ? TextField(
                                  controller: editCategoryController,
                                  decoration: const InputDecoration(isDense: true, border: UnderlineInputBorder()),
                                )
                                    : Text(cat.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                                trailing: isEditing
                                    ? Row( // MODO DE EDIÇÃO
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.check, color: AppColors.primaryGreen),
                                        onPressed: () async {
                                          final newName = editCategoryController.text.trim();
                                          if (newName.isNotEmpty && newName != cat.nome) {
                                            setStateDialog(() => isSaving = true);
                                            await sl<CategoryCacheService>().updateCategory(sl<Dio>(), cat.id, newName);
                                          }
                                          setStateDialog(() {
                                            editingCategoryId = null;
                                            isSaving = false;
                                          });
                                        }),
                                    IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => setStateDialog(() => editingCategoryId = null)),
                                  ],
                                )
                                    : Row( // MODO DE LEITURA
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                        onPressed: () {
                                          setStateDialog(() {
                                            editingCategoryId = cat.id;
                                            editCategoryController.text = cat.nome;
                                          });
                                        }),
                                    IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          setStateDialog(() => isSaving = true);
                                          final success = await sl<CategoryCacheService>().deleteCategory(sl<Dio>(), cat.id);
                                          setStateDialog(() => isSaving = false);

                                          if (!success && mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não é possível apagar uma categoria em uso!'), backgroundColor: Colors.red));
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  void _showPromotionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            double precoOriginal = double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0;
            double percentual = double.tryParse(_percentualDescontoController.text) ?? 0.0;
            double precoFinal = precoOriginal - (precoOriginal * (percentual / 100));

            Color borderColor = Colors.grey.shade400;
            double borderWidth = 1.0;
            if (percentual > 80) {
              borderColor = Colors.red;
              borderWidth = 3.0;
            } else if (percentual > 60) {
              borderColor = AppColors.borderYellow;
              borderWidth = 3.0;
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Configurar Promoção', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _percentualDescontoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) return newValue;
                          int? val = int.tryParse(newValue.text);
                          if (val != null && val > 100) return oldValue;
                          return newValue;
                        }),
                      ],
                      onChanged: (val) => setStateDialog(() {}),
                      decoration: InputDecoration(
                        labelText: 'Porcentagem de Desconto', suffixText: '%',
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.menuBackground, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Preço Final:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('R\$ ${precoFinal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.primaryGreen)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _buildDateTile('Início', _dataInicioPromo, () async {
                          final date = await showDatePicker(
                              context: context,
                              initialDate: _dataInicioPromo ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              // Bloqueia a seleção de dias após a data de fim (se existir)
                              lastDate: _dataFimPromo ?? DateTime(2100)
                          );
                          if (date != null) setStateDialog(() => _dataInicioPromo = date);
                        })),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDateTile('Fim', _dataFimPromo, () async {
                          final date = await showDatePicker(
                              context: context,
                              initialDate: _dataFimPromo ?? (_dataInicioPromo ?? DateTime.now()),
                              // Bloqueia a seleção de dias antes da data de início (se existir)
                              firstDate: _dataInicioPromo ?? DateTime(2000),
                              lastDate: DateTime(2100)
                          );
                          if (date != null) setStateDialog(() => _dataFimPromo = date);
                        })),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                  onPressed: () { setState(() {}); Navigator.pop(context); },
                  child: const Text('Aplicar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_categoriasDisponiveveis.isEmpty) _carregarCategoriasDoCache();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isItemLoaded) _buildTopInfoBar(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldRow('Nome', _nomeController, _lockNome, () => setState(() => _lockNome = false), isRequired: true, maxLength: 160),
                    _buildFieldRow('Descrição', _descricaoController, _lockDescricao, () => setState(() => _lockDescricao = false), maxLines: 4, isRequired: true, maxLength: 500),
                    _buildFieldRow('Ingredientes', _ingredientesController, _lockIngredientes, () => setState(() => _lockIngredientes = false), maxLines: 4, maxLength: 500),

                    // NOVO: Botão de Adicionar Categoria abaixo de Ingredientes
                    if (!_lockCategoria)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 120), // Alinha com as caixas de texto
                            TextButton.icon(
                              onPressed: _showManageCategoriesDialog,
                              icon: const Icon(Icons.add_circle, color: AppColors.primaryGreen),
                              label: const Text('Adicionar nova categoria', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildPriceField(),

                    // Dropdown padrão restaurado
                    _buildDropdownRow(
                      'Categoria',
                      _categoriasDisponiveveis,
                      _selectedCategoria,
                      _lockCategoria,
                          () => setState(() => _lockCategoria = false),
                          (val) => setState(() => _selectedCategoria = val),
                      isRequired: true,
                    ),
                    _buildDropdownRow('Status', ['Ativo', 'Inativo', 'Esgotado', 'Bloqueado'], _selectedStatus, _lockStatus, () => setState(() => _lockStatus = false), (val) => setState(() => _selectedStatus = val)),
                    _buildDropdownRow('Medida', ['g', 'kg', 'l', 'ml'], _selectedUnidade, _lockUnidade, () => setState(() => _lockUnidade = false), (val) => setState(() => _selectedUnidade = val)),

                    // Limite máximo de 10 porções mantido via InputFormatter
                    _buildFieldRow('Porções', _porcoesController, _lockPorcoes, () => setState(() => _lockPorcoes = false), isNumber: true, customFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.isEmpty) return newValue;
                        int? val = int.tryParse(newValue.text);
                        if (val != null && val > 10) return oldValue;
                        return newValue;
                      }),
                    ]),

                    _buildFieldRow('Imagem', _imagemController, false, () {}, isFilePicker: true),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
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
            _loadedItemId?.toString().padLeft(3, '0') ?? '---',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryOrange),
          ),
          const Spacer(),
          if (_hasActivePromotion()) ...[
            _buildPromoBadge(),
            const SizedBox(width: 16),
            Text('Valor Atual: R\$ ${_getCalculatedPromotionalPrice().toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryGreen)),
          ]
        ],
      ),
    );
  }

  Widget _buildPriceField() {
    return _buildBaseRow('Preço', Row(
      children: [
        Expanded(
          child: TextField(
            controller: _precoController,
            readOnly: _lockPreco,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [CurrencyInputFormatter()],
            style: TextStyle(fontFamily: 'Roboto', color: _lockPreco ? Colors.grey : Colors.black),
            decoration: _inputDecoration(null).copyWith(
              prefixText: 'R\$ ',
              suffixIcon: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VerticalDivider(color: AppColors.borderYellow, thickness: 1.5, indent: 10, endIndent: 10),
                    IconButton(
                      icon: const Icon(Icons.local_offer, color: AppColors.primaryOrange),
                      onPressed: _showPromotionDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_lockPreco) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: () => setState(() => _lockPreco = false)),
      ],
    ), isRequired: true);
  }

  Widget _buildFieldRow(String label, TextEditingController controller, bool isLocked, VoidCallback onUnlock, {int maxLines = 1, bool isRequired = false, bool isNumber = false, bool isFilePicker = false, int? maxLength, List<TextInputFormatter>? customFormatters}) {

    List<TextInputFormatter> formatters = [];
    if (isNumber) formatters.add(FilteringTextInputFormatter.digitsOnly);
    if (customFormatters != null) formatters.addAll(customFormatters);

    return _buildBaseRow(label, Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            readOnly: isLocked || isFilePicker,
            inputFormatters: formatters.isNotEmpty ? formatters : null,
            onTap: isFilePicker ? _pickImage : null,
            style: TextStyle(fontFamily: 'Roboto', color: isLocked ? Colors.grey : Colors.black),
            decoration: _inputDecoration(null).copyWith(
                suffixIcon: isFilePicker ? const Icon(Icons.attach_file) : null
            ),
          ),
        ),
        if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock),
      ],
    ), isRequired: isRequired);
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
              decoration: _inputDecoration(null).copyWith(
                fillColor: isLocked ? Colors.grey.shade100 : Colors.white,
              ),
            ),
          ),
        ),
        if (isLocked) IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onUnlock),
      ],
    ), isRequired: isRequired);
  }

  Widget _buildBaseRow(String label, Widget child, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Padding(padding: const EdgeInsets.only(top: 14.0), child: RichText(text: TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontFamily: 'Roboto'), children: [if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red))])))),
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

  bool _hasActivePromotion() => _percentualDescontoController.text.isNotEmpty && (_dataFimPromo?.isAfter(DateTime.now()) ?? false);

  double _getCalculatedPromotionalPrice() {
    double p = double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0;
    double d = double.tryParse(_percentualDescontoController.text) ?? 0.0;
    return p - (p * (d / 100));
  }

  Widget _buildPromoBadge() => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(20)), child: Row(children: const [Icon(Icons.local_offer, color: Colors.red, size: 16), SizedBox(width: 8), Text('Promoção Ativa', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))]));

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isItemLoaded)
          _buildActionButton('Deletar', Colors.red, _onDeletePressed),
        const SizedBox(width: 16),
        _buildActionButton('Limpar', AppColors.primaryYellow, _clearForm, textColor: Colors.black),
        const SizedBox(width: 16),
        _buildActionButton('Salvar', AppColors.primaryGreen, _onSavePressed),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed, {Color textColor = Colors.white}) => SizedBox(height: 48, width: 140, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: onPressed, child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold))));

  Widget _buildDateTile(String label, DateTime? date, VoidCallback onTap) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), const SizedBox(height: 8), InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryOrange), const SizedBox(width: 8), Text(date == null ? 'Selecionar' : '${date.day}/${date.month}/${date.year}')])))]);

  Future<void> _pickImage() async {
    FilePickerResult? r = await FilePicker.pickFiles(type: FileType.image);
    if (r != null) setState(() => _imagemController.text = r.files.single.name);
  }

  void _onSavePressed() async {
    if (_nomeController.text.isEmpty || _precoController.text.isEmpty || _selectedCategoria == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatórios (*)!'), backgroundColor: Colors.red),
      );
      return;
    }

    _showLoadingDialog();

    try {
      final novoProduto = MenuItemModel(
        id: _loadedItemId ?? 0,
        nome: _nomeController.text,
        valorUnidade: double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0,
        unidadeMedida: _selectedUnidade ?? 'g',
        descricao: _descricaoController.text,
        ingredientes: _ingredientesController.text,
        porcoesPorPessoa: int.tryParse(_porcoesController.text),
        status: _selectedStatus?.toUpperCase() ?? 'ATIVO',
        categoriaNome: _selectedCategoria!,
        foto: _imagemController.text,
        valorPromocional: _percentualDescontoController.text.isNotEmpty ? _getCalculatedPromotionalPrice() : null,
        inicioPromocao: _dataInicioPromo,
        terminoPromocao: _dataFimPromo,
      );

      await sl<MenuCacheService>().saveProduct(sl<Dio>(), novoProduto);

      if (mounted) {
        // FORÇA o encerramento do Modal de Loading usando o RootNavigator
        Navigator.of(context, rootNavigator: true).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto salvo com sucesso! ✅'),
            backgroundColor: AppColors.primaryGreen,
            duration: Duration(seconds: 3),
          ),
        );
        _clearForm();
      }
    } on DioException catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fecha o Loading

        String mensagemErro = "Não foi possível enviar, tente novamente mais tarde";
        if (e.response?.statusCode == 409) {
          mensagemErro = "Verifique se o ítem já existe e tente novamente";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagemErro), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fecha o Loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro inesperado, tente novamente'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _onDeletePressed() async {
    if (_loadedItemId == null) return;

    // 1. Abre o alerta e ESPERA a resposta do usuário (true ou false)
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('Confirmar Exclusão', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text('Tem a certeza que deseja inativar este produto? Ele não aparecerá mais no cardápio de vendas.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Retorna false
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true), // Retorna true
              child: const Text('Inativar Produto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    // Se ele fechou o alerta por fora ou clicou em Cancelar, encerra a função
    if (confirmar != true) return;

    // 2. Agora sim, com o alerta anterior já morto, abrimos o Loading limpo
    _showLoadingDialog();

    try {
      await sl<MenuCacheService>().deleteProduct(sl<Dio>(), _loadedItemId!);

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto inativado com sucesso!'), backgroundColor: AppColors.primaryGreen),
        );
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao inativar o produto. Tente novamente.'), backgroundColor: Colors.red),
        );
      }
    }
  }


  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Usuário não pode fechar manualmente
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      ),
    );
  }
}