import '../../../../core/cache/category_cache_service.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.nome,
    required super.valorUnidade,
    required super.unidadeMedida,
    super.descricao,
    super.ingredientes,
    super.porcoesPorPessoa,
    super.inicioPromocao,
    super.valorPromocional,
    super.terminoPromocao,
    super.foto,
    required super.status,
    required super.categoriaNome,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      // Conversão segura de double (mesmo que o JSON envie inteiro)
      valorUnidade: (json['valorUnidade'] as num).toDouble(),
      unidadeMedida: json['unidadeMedida'] as String,
      descricao: json['descricao'] as String?,
      ingredientes: json['ingredientes'] as String?,
      porcoesPorPessoa: json['porcoesPorPessoa'] as int?,
      // Conversão de datas ISO 8601
      inicioPromocao: json['inicioPromocao'] != null ? DateTime.parse(json['inicioPromocao']) : null,
      valorPromocional: json['valorPromocional'] != null ? (json['valorPromocional'] as num).toDouble() : null,
      terminoPromocao: json['terminoPromocao'] != null ? DateTime.parse(json['terminoPromocao']) : null,
      foto: _cleanFotoString(json['foto'] as String?),
      status: json['status'] as String,
      // Extrai o nome da categoria que vem como sub-objeto
      categoriaNome: json['categoria']['nome'] as String,
    );
  }

  // Método auxiliar para limpar a string estranha que está a vir do seu backend
  // (ex: " private String foto = 'https...'")
  static String? _cleanFotoString(String? raw) {
    if (raw == null) return null;
    if (raw.contains('private String foto =')) {
      final match = RegExp(r"'(.*?)'").firstMatch(raw);
      return match?.group(1);
    }
    return raw;
  }

  Map<String, dynamic> toJson() {
    final categoriaIdEncontrada = sl<CategoryCacheService>()
        .categories
        .firstWhere((c) => c.nome == categoriaNome)
        .id;

    // Retorna APENAS os campos mapeados no seu CardapioRequestDTO
    return {
      'nome': nome,
      'valorUnidade': valorUnidade,
      'unidadeMedida': unidadeMedida,
      'descricao': descricao?.isEmpty == true ? null : descricao,
      'ingredientes': ingredientes?.isEmpty == true ? null : ingredientes,
      'porcoesPorPessoa': porcoesPorPessoa,
      'inicioPromocao': inicioPromocao?.toUtc().toIso8601String(),
      'valorPromocional': valorPromocional,
      'terminoPromocao': terminoPromocao?.toUtc().toIso8601String(),
      'foto': foto?.isEmpty == true ? null : foto,
      'status': status.toUpperCase(),
      'categoriaId': categoriaIdEncontrada
    };
  }
}