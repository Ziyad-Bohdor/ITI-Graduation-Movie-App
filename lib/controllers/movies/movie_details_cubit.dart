import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie-model.dart';
import '../../services/tmdb_service.dart';
import 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final TmdbService tmdbService;

  MovieDetailsCubit(this.tmdbService)
      : super(MovieDetailsInitial());

  Future<void> getMovieDetails(int movieId) async {
    emit(MovieDetailsLoading());

    try {
      final response = await tmdbService.getMovieDetails(movieId);

      final movie = MovieModel.fromJson(response.data);

      emit(MovieDetailsSuccess(movie));
    } catch (e) {
      emit(MovieDetailsError(e.toString()));
    }
  }
}