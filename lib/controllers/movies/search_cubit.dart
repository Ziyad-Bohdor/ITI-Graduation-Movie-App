import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_movie_app/models/movie-model.dart';

import '../../services/tmdb_service.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final TmdbService tmdbService;

  SearchCubit(this.tmdbService) : super(SearchInitial());

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final response = await tmdbService.searchMovies(query);

      final List moviesJson = response.data['results'];

      final movies = moviesJson
          .map((movie) => MovieModel.fromJson(movie))
          .toList();

      emit(SearchSuccess(movies));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}