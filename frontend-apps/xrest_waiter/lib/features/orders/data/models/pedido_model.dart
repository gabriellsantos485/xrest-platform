class ItemPedidoModel {
  final int id;
  final int quantidade;
  final double valorUnitario;
  final double valorDescontado;
  final double valorTotal;
  final String observacoes;
  final int pedidoId;
  final String cardapioName;
  final String status;

  ItemPedidoModel({
    required this.id, required this.quantidade, required this.valorUnitario,
    required this.valorDescontado, required this.valorTotal, required this.observacoes,
    required this.pedidoId, required this.cardapioName, required this.status,
  });

  factory ItemPedidoModel.fromJson(Map<String, dynamic> json) {
    return ItemPedidoModel(
      id: json['id'] ?? 0,
      quantidade: json['quantidade'] ?? 1,
      valorUnitario: (json['valorUnitario'] ?? 0.0).toDouble(),
      valorDescontado: (json['valorDescontado'] ?? 0.0).toDouble(),
      valorTotal: (json['valorTotal'] ?? 0.0).toDouble(),
      observacoes: json['observacoes'] ?? '',
      pedidoId: json['pedidoId'] ?? 0,
      cardapioName: json['cardapioId'] ?? '',
      status: json['status'] ?? 'EM_PREPARO',
    );
  }
}

class PedidoModel {
  final int id;
  final bool viagem;
  final String criadoEm;
  final double valorTotal;
  final String status;
  final int? quantidadePessoas;
  final String? clienteNome;
  final int? mesaId;
  final int? funcionarioId;
  final List<ItemPedidoModel> itens; // <-- Nova lista de itens integrada!

  PedidoModel({
    required this.id, required this.viagem, required this.criadoEm,
    required this.valorTotal, required this.status, this.quantidadePessoas,
    this.clienteNome, this.mesaId, this.funcionarioId, required this.itens,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      id: json['id'] ?? 0,
      viagem: json['viagem'] ?? false,
      criadoEm: json['criadoEm'] ?? '',
      valorTotal: (json['valorTotal'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'ABERTO',
      quantidadePessoas: json['quantidadePessoas'],
      clienteNome: json['clienteNome']?.toString() ?? json['cliente']?.toString(),
      mesaId: json['mesaId'],
      funcionarioId: json['funcionarioId'],
      // Converte o array de itens do JSON para a lista do Flutter
      itens: json['itens'] != null
          ? (json['itens'] as List).map((i) => ItemPedidoModel.fromJson(i)).toList()
          : [],
    );
  }
}