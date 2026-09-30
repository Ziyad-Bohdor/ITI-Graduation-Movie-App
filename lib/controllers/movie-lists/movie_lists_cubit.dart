import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_movie_app/models/movie-model.dart';

import '../../models/movie_list_model.dart';
import '../../services/firestore_service.dart';
import 'movie_lists_state.dart';

class MovieListsCubit extends Cubit<MovieListsState> {
  final FirestoreService firestoreService;

  MovieListsCubit(this.firestoreService)
      : super(MovieListsInitial());

  Future<void> loadMovies({
    required String uid,
    required String listType,
  }) async {
    emit(MovieListsLoading());

    try {
      final movies = await firestoreService.getMovies(
        uid: uid,
        listType: listType,
      );

      if (isClosed) return;

      emit(MovieListsSuccess(movies));
    } catch (e) {
      if (isClosed) return;

      emit(MovieListsError(e.toString()));
    }
  }

  Future<String?> addMovie({
    required String uid,
    required String listType,
    required MovieModel movie,
  }) async {
    try {
      final movieList = MovieListModel(
        movieId: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
      );

      await firestoreService.addMovie(
        uid: uid,
        listType: listType,
        movie: movieList,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> removeMovie({
    required String uid,
    required String listType,
    required int movieId,
  }) async {
    try {
      await firestoreService.removeMovie(
        uid: uid,
        listType: listType,
        movieId: movieId,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}