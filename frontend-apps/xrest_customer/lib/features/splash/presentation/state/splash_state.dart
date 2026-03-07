/*
 * File: splash_state.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Defines the lifecycle states of the application's initialization process.
 */

import 'package:equatable/equatable.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any boot processes begin.
final class SplashInitial extends SplashState {
  const SplashInitial();
}

/// State representing ongoing initialization (e.g., loading tokens, warming up DB).
final class SplashLoading extends SplashState {
  const SplashLoading();
}

/// State representing a successful boot. The UI must react by navigating to the main flow.
final class SplashReady extends SplashState {
  const SplashReady();
}