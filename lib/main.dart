import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iti_movie_app/services/tmdb_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

   final tmdbService = TmdbService();

  try {
    final response = await tmdbService.getPopularMovies();

    print(response.data);
  } catch (e) {
    print('TMDB ERROR: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Movie App'),
        ),
      ),
    );
  }
}