/*
 * File: auth_wrapper_page.dart
 * Author: Elite Software Architect Agent
 * Date: 2026-03-06
 * Description: Acts as an Auth Guard. Listens to the global AuthBloc and dynamically
 * routes the user to either the Login/Register flow or their Profile page.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/auth_bloc.dart';
import '../state/auth_state.dart';
import 'login_page.dart';
import 'profile_page.dart';

class AuthWrapperPage extends StatelessWidget {
  const AuthWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFF8C00)),
            ),
          );
        }

        if (state is Authenticated) {
          // User has a valid session. Render the Profile Dashboard.
          return ProfilePage(client: state.client);
        }

        // Fallback for Unauthenticated, AuthInitial, or AuthError states.
        return const LoginPage();
      },
    );
  }
}