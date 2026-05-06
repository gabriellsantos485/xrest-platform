/*
 * File: lib/features/auth/presentation/bloc/auth_event.dart
 * Author: Elite Flutter Agent
 * Date: 2026-05-01
 * Description: Defines the events that can be dispatched to the AuthBloc.
 */

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}