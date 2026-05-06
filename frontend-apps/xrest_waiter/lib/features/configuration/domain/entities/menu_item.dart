class MenuItem {
  final int id;
  final String nome;
  final double valorUnidade;
  final String unidadeMedida;
  final String? descricao;
  final String? ingredientes;
  final int? porcoesPorPessoa;
  final DateTime? inicioPromocao;
  final double? valorPromocional;
  final DateTime? terminoPromocao;
  final String? foto;
  final String status;
  final String categoriaNome;

  const MenuItem({
    required this.id,
    required this.nome,
    required this.valorUnidade,
    required this.unidadeMedida,
    this.descricao,
    this.ingredientes,
    this.porcoesPorPessoa,
    this.inicioPromocao,
    this.valorPromocional,
    this.terminoPromocao,
    this.foto,
    required this.status,
    required this.categoriaNome,
  });

  // Regra de negócio nativa: Verifica se a promoção está ativa hoje
  bool get hasActivePromotion {
    if (valorPromocional == null || terminoPromocao == null) return false;
    return terminoPromocao!.isAfter(DateTime.now());
  }
}