/*
 * File: user_model.dart
 * Author: Elite Flutter Agent
 * Date: 2026-05-01
 * Description: Data Transfer Object (DTO) for handling JSON serialization from the API.
 */

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      role: json['role'] as String,
    );
  }
}