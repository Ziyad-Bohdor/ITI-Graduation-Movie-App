import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TmdbService {
  final Dio dio = Dio();

  final String apiKey = dotenv.env['TMDB_API_KEY']!;

  Future<Response> getPopularMovies() async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/popular',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
        'page': 1,
      },
    );

    return response;
  }

  Future<Response> getTopRatedMovies() async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/top_rated',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
        'page': 1,
      },
    );

    return response;
  }

  Future<Response> getNowPlayingMovies() async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/now_playing',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
        'page': 1,
      },
    );

    return response;
  }

  Future<Response> getUpcomingMovies() async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/upcoming',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
        'page': 1,
      },
    );

    return response;
  }

  Future<Response> searchMovies(String query) async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/search/movie',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
        'query': query,
      },
    );

    return response;
  }

  Future<Response> getMovieDetails(int movieId) async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/$movieId',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
      },
    );

    return response;
  }
}