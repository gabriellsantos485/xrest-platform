/*
 * File: auth_repository_impl.dart
 * Author: Elite Flutter Agent
 * Date: 2026-05-01
 * Description: Concrete implementation of AuthRepository. Connects Domain with Data sources.
 */

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login({required String email, required String password}) async {
    return await remoteDataSource.login(email, password);
  }
}