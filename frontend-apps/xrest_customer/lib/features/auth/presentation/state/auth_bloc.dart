import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/entities/client_entity.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterClientEvent>(_onRegisterClient);
  }

  Future<void> _onRegisterClient(RegisterClientEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final uri = Uri.parse('http://192.168.18.102:8080/xrest/cliente/cadastrar');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(event.payload),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sucesso! Pode extrair os dados da resposta se a API devolver o cliente criado
        // Para já, emitimos o estado de Autenticado com um mock do ID
        final client = ClientEntity(
          id: 'registrado_com_sucesso', // Idealmente viria do response.body
          firstName: event.payload['nome'],
          lastName: event.payload['sobrenome'],
          cpf: event.payload['cpf'],
          phone: event.payload['telefone'],
          email: event.payload['email'],
          address: '${event.payload['rua']}, ${event.payload['numeroCasa']} - ${event.payload['cidade']}',
        );

        emit(Authenticated(client: client));
      } else {
        emit(AuthError(message:'Falha no cadastro: ${response.body}'));
      }
    } catch (e) {
      emit(AuthError(message:'Erro de conexão com o servidor. Tente novamente.'));
    }
  }
}