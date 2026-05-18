import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class DoLoginUseCase {
  final AuthRepository repository;

  DoLoginUseCase(this.repository);

  Future<User> call({required String email, required String password}) async {
    // Business rule validations
    if (email.trim().isEmpty) {
      throw Exception('O e-mail não pode estar vazio.');
    }
    if (password.trim().isEmpty) {
      throw Exception('A senha não pode estar vazia.');
    }

    // Delegation to the data layer
    return await repository.login(email: email, password: password);
  }
}