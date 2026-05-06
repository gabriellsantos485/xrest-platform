/*
 * File: lib/features/auth/presentation/bloc/auth_bloc.dart
 * Author: Elite Flutter Agent
 * Date: 2026-05-01
 * Description: Manages the state of authentication, reacting to AuthEvents and executing the UseCase.
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/do_login_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DoLoginUseCase doLogin;

  AuthBloc({required this.doLogin}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Executes the business logic defined in the Domain layer
      final user = await doLogin(email: event.email, password: event.password);
      emit(AuthSuccess(user: user));
    } catch (e) {
      // Strips out the "Exception:" prefix for a cleaner UI message
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}