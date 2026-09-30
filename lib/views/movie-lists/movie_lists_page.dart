import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/movie-lists/movie_lists_cubit.dart';
import '../../controllers/movie-lists/movie_lists_state.dart';
import '../../services/firestore_service.dart';
import '../../widgets/movie_list_card.dart';

class MovieListsPage extends StatelessWidget {
  MovieListsPage({super.key});

  final List<String> listTypes = [
    'favorites',
    'watched',
    'watching',
    'want_to_watch',
  ];

  final List<String> listTitles = [
    'Favorites',
    'Watched',
    'Watching',
    'Want to Watch',
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login first'),
        ),
      );
    }

    return BlocProvider(
      create: (_) => MovieListsCubit(
        FirestoreService(),
      )..loadMovies(
          uid: user.uid,
          listType: 'favorites',
        ),
      child: DefaultTabController(
        length: listTypes.length,
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Movie Lists'),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: listTitles
                      .map(
                        (title) => Tab(
                          text: title,
                        ),
                      )
                      .toList(),
                  onTap: (index) {
                    context.read<MovieListsCubit>().loadMovies(
                          uid: user.uid,
                          listType: listTypes[index],
                        );
                  },
                ),
              ),
              body: BlocBuilder<MovieListsCubit, MovieListsState>(
                builder: (context, state) {
                  if (state is MovieListsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is MovieListsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (state is MovieListsSuccess) {
                    if (state.movies.isEmpty) {
                      return const Center(
                        child: Text(
                          'No movies in this list',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    final currentIndex =
                        DefaultTabController.of(context).index;

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.movies.length,
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];

                        return MovieListCard(
                          movie: movie,
                          onDelete: () async {
                            final error = await context
                                .read<MovieListsCubit>()
                                .removeMovie(
                                  uid: user.uid,
                                  listType: listTypes[currentIndex],
                                  movieId: movie.movieId,
                                );

                            if (!context.mounted) return;

                            if (error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                ),
                              );
                              return;
                            }

                            context
                                .read<MovieListsCubit>()
                                .loadMovies(
                                  uid: user.uid,
                                  listType: listTypes[currentIndex],
                                );
                          },
                        );
                      },
                    );
                  }

                  return const Center(
                    child: Text('No movies loaded'),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}