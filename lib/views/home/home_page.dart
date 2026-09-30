import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/movies/movies_cubit.dart';
import '../../controllers/movies/movies_state.dart';
import '../../services/tmdb_service.dart';
import '../../widgets/movie_card.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget buildMovieSection({
    required String title,
    required MoviesState state,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        if (state is MoviesLoading)
          const SizedBox(
            height: 280,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),

        if (state is MoviesError)
          SizedBox(
            height: 280,
            child: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ),
          ),

        if (state is MoviesSuccess)
          SizedBox(
            height: 290,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: state.movies.length,
              separatorBuilder: (_, index) {
                return const SizedBox(width: 12);
              },
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 150,
                  child: MovieCard(
                    movie: state.movies[index],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MoviesCubit(
            TmdbService(),
          )..getPopularMovies(),
        ),

        BlocProvider(
          create: (_) => MoviesCubit(
            TmdbService(),
          )..getTopRatedMovies(),
        ),

        BlocProvider(
          create: (_) => MoviesCubit(
            TmdbService(),
          )..getNowPlayingMovies(),
        ),

        BlocProvider(
          create: (_) => MoviesCubit(
            TmdbService(),
          )..getUpcomingMovies(),
        ),
      ],
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

  body: SingleChildScrollView(
  child: Column(
    children: [
      BlocProvider(
        create: (_) => MoviesCubit(
          TmdbService(),
        )..getPopularMovies(),
        child: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            return buildMovieSection(
              title: 'Popular Movies',
              state: state,
            );
          },
        ),
      ),

      BlocProvider(
        create: (_) => MoviesCubit(
          TmdbService(),
        )..getTopRatedMovies(),
        child: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            return buildMovieSection(
              title: 'Top Rated Movies',
              state: state,
            );
          },
        ),
      ),

      BlocProvider(
        create: (_) => MoviesCubit(
          TmdbService(),
        )..getNowPlayingMovies(),
        child: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            return buildMovieSection(
              title: 'Now Playing',
              state: state,
            );
          },
        ),
      ),

      BlocProvider(
        create: (_) => MoviesCubit(
          TmdbService(),
        )..getUpcomingMovies(),
        child: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            return buildMovieSection(
              title: 'Upcoming Movies',
              state: state,
            );
          },
        ),
      ),
    ],
  ),
),
      ),
    );
  }
}