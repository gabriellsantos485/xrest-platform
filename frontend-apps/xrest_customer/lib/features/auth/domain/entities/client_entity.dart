/*
 * File: client_entity.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Domain entity representing a registered customer.
 * Agnostic to any database or framework implementation.
 */

class ClientEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String cpf;
  final String phone;
  final String email;
  // In a complete implementation, address would be its own Value Object or Entity.
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