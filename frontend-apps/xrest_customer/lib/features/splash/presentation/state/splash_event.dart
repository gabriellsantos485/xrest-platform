/*
 * File: splash_event.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Defines the trigger events for the application's initialization sequence.
 */

import 'package:equatable/equatable.dart';

sealed class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched immediately when the Splash UI is mounted.
final class InitializeAppEvent extends SplashEvent {
  const InitializeAppEvent();
}