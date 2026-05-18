class MesaModel {
  final int id;
  final String status;      // Ex: EM_LIMPEZA, LIVRE, LOTADA, RESERVADA, MANUTENCAO
  final String localizacao; // Ex: P (Primeiro), S (Segundo)
  final int capacidade;     // Max 20

  MesaModel({
    required this.id,
    required this.status,
    required this.localizacao,
    required this.capacidade,
  });

  factory MesaModel.fromJson(Map<String, dynamic> json) {
    return MesaModel(
      id: json['id'] ?? 0,
      status: json['status']?.toString() ?? 'LIVRE',
      localizacao: json['localizacao']?.toString() ?? 'P',
      capacidade: json['capacidade'] != null ? int.parse(json['capacidade'].toString()) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "localizacao": localizacao,
      "capacidade": capacidade,
    };
  }
}