import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/client_entity.dart';
import '../state/auth_bloc.dart';
import '../state/auth_event.dart';

class ProfilePage extends StatelessWidget {
  final ClientEntity client;

  const ProfilePage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MEU PERFIL',
          style: TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              // Dispatches event to clear session and automatically updates the Wrapper
              context.read<AuthBloc>().add(const LogoutEvent());
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFFFC107),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 24),

          Center(
            child: Text(
              '${client.firstName} ${client.lastName}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          Center(
            child: Text(
              client.email,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),

          _buildInfoTile(Icons.badge, 'CPF', client.cpf),
          const Divider(),
          _buildInfoTile(Icons.phone, 'Telemóvel', client.phone),
          const Divider(),
          _buildInfoTile(Icons.home, 'Morada Principal', client.address),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF8C00)),
      title: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      subtitle: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}