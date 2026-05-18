import 'package:equatable/equatable.dart';
import '../../domain/entities/client_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Authenticated extends AuthState {
  final ClientEntity client;

  const Authenticated({required this.client});

  @override
  List<Object?> get props => [client];
}

final class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}