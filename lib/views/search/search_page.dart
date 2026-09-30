import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/movies/search_cubit.dart';
import '../../controllers/movies/search_state.dart';
import '../../services/tmdb_service.dart';
import '../../widgets/movie_card.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final TextEditingController searchController =
      TextEditingController();

  @override
 @override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (_) => SearchCubit(TmdbService()),
    child: Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search Movies'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a movie...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (value) {
                    context.read<SearchCubit>().searchMovies(value);
                  },
                ),
              ),

              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is SearchError) {
                      return Center(
                        child: Text(state.message),
                      );
                    }

                    if (state is SearchSuccess) {
                      if (state.movies.isEmpty) {
                        return const Center(
                          child: Text('No movies found'),
                        );
                      }

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

                    return const Center(
                      child: Text('Search for a movie'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
}