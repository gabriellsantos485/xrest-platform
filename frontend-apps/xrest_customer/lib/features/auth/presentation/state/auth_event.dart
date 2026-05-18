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
  final Map<String, dynamic> payload;
  const RegisterClientEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}

final class LogoutEvent extends AuthEvent {
  const LogoutEvent();

}
