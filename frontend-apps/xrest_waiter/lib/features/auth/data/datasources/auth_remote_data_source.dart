
import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    try {

      await Future.delayed(const Duration(seconds: 2)); // Simulates network delay
      if (email == 'teste@xrest.com' && password == '123456') {
        return const UserModel(
          id: 1,
          name: 'Administrador',
          email: 'teste@xrest.com',
          token: 'mock_jwt_token_123',
          role: 'ADMIN',
        );
      } else {
        throw Exception('Credenciais inválidas. Tente teste@xrest.com / 123456.');
      }
      // -----------------------

    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Erro de conexão com o servidor.');
    }
  }
}