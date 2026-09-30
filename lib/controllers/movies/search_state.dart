import 'package:equatable/equatable.dart';
import 'package:iti_movie_app/models/movie-model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<MovieModel> movies;

  const SearchSuccess(this.movies);

  @override
  List<Object?> get props => [movies];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}