/*
 * File: auth_repository.dart
 * Author: Elite Flutter Agent
 * Date: 2026-05-01
 * Description: Abstract contract defining the authentication capabilities required by the UseCases.
 */

import '../entities/user.dart';

abstract class AuthRepository {
  /// Authenticates a user using email and password.
  Future<User> login({required String email, required String password});
}