/*
 * File: user.dart
 * Author: Elite Flutter Agent
 * Date: 2026-05-01
 * Description: Core business entity representing an authenticated user (Employee/Admin).
 */

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String token;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.role,
  });

  @override
  List<Object?> get props => [id, name, email, token, role];
}