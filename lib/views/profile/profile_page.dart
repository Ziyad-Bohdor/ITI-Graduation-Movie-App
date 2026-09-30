import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/auth/auth_cubit.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await context.read<AuthCubit>().signOut();

            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
              (route) => false,
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}