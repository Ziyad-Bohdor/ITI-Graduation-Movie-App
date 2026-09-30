class MovieListModel {
  final int movieId;
  final String title;
  final String posterPath;

  MovieListModel({
    required this.movieId,
    required this.title,
    required this.posterPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'title': title,
      'posterPath': posterPath,
    };
  }

  factory MovieListModel.fromJson(Map<String, dynamic> json) {
    return MovieListModel(
      movieId: json['movieId'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['posterPath'] ?? '',
    );
  }
}