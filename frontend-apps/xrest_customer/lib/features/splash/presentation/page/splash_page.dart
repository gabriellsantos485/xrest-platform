/*
 * File: splash_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Splash screen UI featuring a 60fps 'Chasing Border' animation
 * around a static SVG logo, integrated with SplashBloc for safe routing.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/presentation/pages/main_layout_page.dart';
import '../state/splash_bloc.dart';
import '../state/splash_event.dart';
import '../state/splash_state.dart';
import '../../../menu/presentation/pages/menu_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

/// Uses SingleTickerProviderStateMixin to sync the AnimationController with the screen refresh rate.
class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // Initializes the motor for the infinite rotation (duration defines speed)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(); // Infinite loop

    // Dispatches the boot event to the BLoC as soon as the screen is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashBloc>().add(const InitializeAppEvent());
    });
  }

  @override
  void dispose() {
    // CRITICAL: Prevent memory leaks by destroying the animation motor
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashReady) {
          // Replaces the Splash screen in the navigation stack so the user cannot navigate back to it
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (_, __, ___) => const MainLayoutPage(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _buildChasingBorderLogo(),
        ),
      ),
    );
  }

  /// Constructs the 3-layer architecture for the Chasing Border effect.
  Widget _buildChasingBorderLogo() {
    // Sizing constants
    const double outerSize = 180.0;
    const double innerMaskSize = 170.0; // Leaves a 5px border
    const double logoSize = 90.0; // Medium size for the hamburger

    return Stack(
      alignment: Alignment.center,
      children: [
        // Layer 1: The Engine (Animated SweepGradient)
        RotationTransition(
          turns: _rotationController,
          child: Container(
            width: outerSize,
            height: outerSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xFFFFC107), // Vibrant Yellow
                  Color(0xFFE53935), // Vibrant Red
                ],
                stops: [0.0, 0.5, 0.9, 1.0], // Concentrates the color at the tail
              ),
            ),
          ),
        ),

        // Layer 2: The Mask (Matches Scaffold background to hide the center of the gradient)
        Container(
          width: innerMaskSize,
          height: innerMaskSize,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),

        // Layer 3: The Static SVG Logo
        SvgPicture.asset(
          'assets/images/hamburguer.svg', // Ensure this path matches your pubspec.yaml
          width: logoSize,
          height: logoSize,
          // Fallback while asset is not added
          placeholderBuilder: (context) => const Icon(
            Icons.fastfood,
            size: logoSize,
            color: Color(0xFFFF8C00),
          ),
        ),
      ],
    );
  }
}