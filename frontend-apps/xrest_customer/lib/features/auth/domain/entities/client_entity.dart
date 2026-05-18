class ClientEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String cpf;
  final String phone;
  final String email;

  final String address;

  const ClientEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.cpf,
    required this.phone,
    required this.email,
    required this.address,
  });
}