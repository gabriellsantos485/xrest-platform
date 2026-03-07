/*
 * File: auth_event.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Defines events to trigger authentication processes.
 */

import 'package:equatable/equatable.dart';
import '../../domain/entities/client_entity.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class CheckAuthSessionEvent extends AuthEvent {
  const CheckAuthSessionEvent();
}

final class RegisterClientEvent extends AuthEvent {
  final ClientEntity newClient;
  final String password;

  const RegisterClientEvent({required this.newClient, required this.password});

  @override
  List<Object?> get props => [newClient, password];
}

final class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}