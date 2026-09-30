import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_movie_app/controllers/movie-lists/movie_lists_cubit.dart';
import 'package:iti_movie_app/services/firestore_service.dart';

import '../../controllers/movies/movie_details_cubit.dart';
import '../../controllers/movies/movie_details_state.dart';
import '../../services/tmdb_service.dart';

class MovieDetailsPage extends StatelessWidget {
  final int movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MovieDetailsCubit(
            TmdbService(),
          )..getMovieDetails(movieId),
        ),
        BlocProvider(
          create: (_) => MovieListsCubit(
            FirestoreService(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Details'),
        ),

        body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is MovieDetailsError) {
              return Center(
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (state is MovieDetailsSuccess) {
              final movie = state.movie;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (movie.backdropPath.isNotEmpty)
                      Image.network(
                        'https://image.tmdb.org/t/p/w780${movie.backdropPath}',
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 5),

                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                              ),

                              const SizedBox(width: 20),

                              Text(movie.releaseDate),
                            ],
                          ),

                          const SizedBox(height: 20),

                          if (movie.posterPath.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                height: 350,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                          const SizedBox(height: 20),

                          const Text(
                            'Overview',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            movie.overview.isEmpty
                                ? 'No overview available.'
                                : movie.overview,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final user =
                                    FirebaseAuth.instance.currentUser;

                                if (user == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please login first',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final selectedList =
                                    await showModalBottomSheet<String>(
                                  context: context,
                                  builder: (context) {
                                    return SafeArea(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Icons.favorite,
                                            ),
                                            title: const Text(
                                              'Favorites',
                                            ),
                                            onTap: () {
                                              Navigator.pop(
                                                context,
                                                'favorites',
                                              );
                                            },
                                          ),

                                          ListTile(
                                            leading: const Icon(
                                              Icons.visibility,
                                            ),
                                            title: const Text(
                                              'Watched',
                                            ),
                                            onTap: () {
                                              Navigator.pop(
                                                context,
                                                'watched',
                                              );
                                            },
                                          ),

                                          ListTile(
                                            leading: const Icon(
                                              Icons.play_circle,
                                            ),
                                            title: const Text(
                                              'Watching',
                                            ),
                                            onTap: () {
                                              Navigator.pop(
                                                context,
                                                'watching',
                                              );
                                            },
                                          ),

                                          ListTile(
                                            leading: const Icon(
                                              Icons.bookmark,
                                            ),
                                            title: const Text(
                                              'Want to Watch',
                                            ),
                                            onTap: () {
                                              Navigator.pop(
                                                context,
                                                'want_to_watch',
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );

                                if (selectedList == null) return;

                                final error = await context
                                    .read<MovieListsCubit>()
                                    .addMovie(
                                      uid: user.uid,
                                      listType: selectedList,
                                      movie: movie,
                                    );

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      error == null
                                          ? 'Movie added successfully'
                                          : error,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text(
                                'Add to My List',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}