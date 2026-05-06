/*
 * File: auth_remote_data_source.dart
 * Author: Elite Flutter Agent
 * Date: 2026-05-01
 * Description: Handles direct HTTP communication with the Spring Boot backend API.
 */

import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
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
      // Mocking the request for UI testing purposes since the backend might not be ready
      // In production, uncomment the Dio call below:
      /*
      final response = await client.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      */

      // --- MOCK SIMULATION ---
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