/*
 * File: splash_bloc.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Orchestrates the application boot sequence, ensuring the UI
 * displays the animation for a minimum duration while async tasks complete.
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitial()) {
    on<InitializeAppEvent>(_onInitializeApp);
  }

  Future<void> _onInitializeApp(
      InitializeAppEvent event,
      Emitter<SplashState> emit,
      ) async {
    emit(const SplashLoading());

    // Represents concurrent initialization tasks (e.g., getIt warmup, local storage).
    // The Future.delayed ensures the user sees the highly-polished animation
    // for at least 3 seconds, avoiding a jarring flash if the app loads too fast.
    await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      // TODO: Add other async initialization futures here, e.g., auth checks.
    ]);

    // Signals the UI that the system is fully booted and ready.
    emit(const SplashReady());
  }
}