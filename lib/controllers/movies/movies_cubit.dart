import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_movie_app/models/movie-model.dart';

import '../../services/tmdb_service.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final TmdbService tmdbService;

  MoviesCubit(this.tmdbService) : super(MoviesInitial());

  Future<void> getPopularMovies() async {
    emit(MoviesLoading());

    try {
      final response = await tmdbService.getPopularMovies();

      final List moviesJson = response.data['results'];

      final movies = moviesJson
          .map((movie) => MovieModel.fromJson(movie))
          .toList();

      emit(MoviesSuccess(movies));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }
}