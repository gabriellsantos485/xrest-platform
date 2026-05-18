class StaffModel {
  final int id;
  final String nome;
  final String sobrenome;
  final String email;
  final String telefone;
  final String cargo;
  final bool status;
  final String username;

  StaffModel({
    required this.id, required this.nome, required this.sobrenome,
    required this.email, required this.telefone, required this.cargo,
    required this.status, required this.username,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      sobrenome: json['sobrenome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
      cargo: json['cargo'] ?? 'GARÇOM',
      status: json['status'] ?? 'true',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    // Tratamento para remover o acento/cedilha antes de enviar para o backend
    String cargoTratado = cargo.toUpperCase();
    if (cargoTratado == 'GARÇOM') {
      cargoTratado = 'GARCOM';
    }

    return {
      "id": id,
      "nome": nome,
      "sobrenome": sobrenome,
      "telefone": telefone,
      "email": email,
      "cargo": cargoTratado, // Envia GARCOM, CAIXA ou ADMIN
      "status": status,
      "username": username,
      "senha": "Mudar123",
    };
  }
}