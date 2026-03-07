/*
 * File: auth_bloc.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Manages the global authentication state of the user session.
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const Unauthenticated()) {
    on<CheckAuthSessionEvent>(_onCheckAuthSession);
    on<RegisterClientEvent>(_onRegisterClient);
    on<LogoutEvent>(_onLogout);
  }

  void _onCheckAuthSession(CheckAuthSessionEvent event, Emitter<AuthState> emit) {
    // TODO: Check local storage for JWT tokens. For now, defaults to Unauthenticated.
    emit(const Unauthenticated());
  }

  Future<void> _onRegisterClient(RegisterClientEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      // Simulating network delay for registration
      await Future.delayed(const Duration(seconds: 2));

      // Mocks a successful registration by immediately logging the user in
      emit(Authenticated(client: event.newClient));
    } catch (e) {
      emit(const AuthError(message: 'Falha ao registrar cliente.'));
      emit(const Unauthenticated());
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    // TODO: Clear local storage tokens.
    emit(const Unauthenticated());
  }
}