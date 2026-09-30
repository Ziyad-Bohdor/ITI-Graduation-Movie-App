import 'package:equatable/equatable.dart';

import '../../models/movie_list_model.dart';

abstract class MovieListsState extends Equatable {
  const MovieListsState();

  @override
  List<Object?> get props => [];
}

class MovieListsInitial extends MovieListsState {}

class MovieListsLoading extends MovieListsState {}

class MovieListsSuccess extends MovieListsState {
  final List<MovieListModel> movies;

  const MovieListsSuccess(this.movies);

  @override
  List<Object?> get props => [movies];
}

class MovieListsError extends MovieListsState {
  final String message;

  const MovieListsError(this.message);

  @override
  List<Object?> get props => [message];
}