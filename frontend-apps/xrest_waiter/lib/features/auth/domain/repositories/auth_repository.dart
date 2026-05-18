import '../entities/user.dart';

abstract class AuthRepository {
  /// Authenticates a user using email and password.
  Future<User> login({required String email, required String password});
}