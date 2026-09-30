import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/auth/auth_cubit.dart';
import '../auth/login_page.dart';
import '../movie-lists/movie_lists_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const CircleAvatar(
              radius: 45,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieListsPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.movie),
                label: const Text('My Movie Lists'),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
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
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}