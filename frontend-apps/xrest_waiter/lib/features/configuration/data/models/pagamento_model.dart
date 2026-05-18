class PagamentoModel {
  final int id;
  final String nome;

  PagamentoModel({
    required this.id,
    required this.nome,
  });

  factory PagamentoModel.fromJson(Map<String, dynamic> json) {
    return PagamentoModel(
      id: json['id'] ?? 0,
      nome: json['nome']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
    };
  }
}