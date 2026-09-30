import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_movie_app/views/profile/profile_page.dart';
import 'package:iti_movie_app/views/search/search_page.dart';

import '../../controllers/movies/movies_cubit.dart';
import '../../controllers/movies/movies_state.dart';
import '../../services/tmdb_service.dart';
import '../../widgets/movie_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoviesCubit(TmdbService())..getPopularMovies(),

      child: Scaffold(
      appBar: AppBar(
  title: const Text('Movie App'),
  actions: [
    IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchPage(),
          ),
        );
      },
      icon: const Icon(Icons.search),
    ),

    IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilePage(),
          ),
        );
      },
      icon: const Icon(Icons.person),
    ),
  ],
),
        body: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            if (state is MoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is MoviesError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is MoviesSuccess) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    movie: state.movies[index],
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}