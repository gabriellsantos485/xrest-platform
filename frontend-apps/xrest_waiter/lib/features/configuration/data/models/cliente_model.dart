class ClienteModel {
  final int id;
  final String nome;
  final String sobrenome;
  final String cpf;
  final String telefone;
  final String email;
  final String cep;
  final String rua;
  final String bairro;
  final String numero;
  final String cidade;

  ClienteModel({
    required this.id, required this.nome, required this.sobrenome,
    required this.cpf, required this.telefone, required this.email,
    required this.cep, required this.rua, required this.bairro,
    required this.numero, required this.cidade,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'] ?? 0,
      nome: json['nome']?.toString() ?? '',
      sobrenome: json['sobrenome']?.toString() ?? '',
      cpf: json['cpf']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cep: json['cep']?.toString() ?? '',
      rua: json['rua']?.toString() ?? '',
      bairro: json['bairro']?.toString() ?? '',
      numero: json['numeroCasa']?.toString() ?? '',
      cidade: json['cidade']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "sobrenome": sobrenome,
      "cpf": cpf,
      "telefone": telefone,
      "email": email,
      "cep": cep,
      "rua": rua,
      "bairro": bairro,
      "numeroCasa": numero,
      "cidade": cidade,
    };
  }
}