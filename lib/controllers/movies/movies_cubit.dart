import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_movie_app/models/movie-model.dart';

import '../../services/tmdb_service.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final TmdbService tmdbService;

  MoviesCubit(this.tmdbService) : super(MoviesInitial());

  Future<void> getPopularMovies() async {
    await _getMovies(
      tmdbService.getPopularMovies,
    );
  }

  Future<void> getTopRatedMovies() async {
    await _getMovies(
      tmdbService.getTopRatedMovies,
    );
  }

  Future<void> getNowPlayingMovies() async {
    await _getMovies(
      tmdbService.getNowPlayingMovies,
    );
  }

  Future<void> getUpcomingMovies() async {
    await _getMovies(
      tmdbService.getUpcomingMovies,
    );
  }

  Future<void> _getMovies(
    Future<dynamic> Function() request,
  ) async {
    emit(MoviesLoading());

    try {
      final response = await request();

      if (isClosed) return;

      final List moviesJson = response.data['results'];

      final movies = moviesJson
          .map((movie) => MovieModel.fromJson(movie))
          .toList();

      if (isClosed) return;

      emit(MoviesSuccess(movies));
    } catch (e) {
      if (isClosed) return;

      emit(MoviesError(e.toString()));
    }
  }
}