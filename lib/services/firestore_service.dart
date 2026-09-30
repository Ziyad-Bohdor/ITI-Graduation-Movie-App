import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/movie_list_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addMovie({
    required String uid,
    required String listType,
    required MovieListModel movie,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('movieLists')
        .doc(listType)
        .collection('movies')
        .doc(movie.movieId.toString())
        .set(movie.toJson());
  }

  Future<void> removeMovie({
    required String uid,
    required String listType,
    required int movieId,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('movieLists')
        .doc(listType)
        .collection('movies')
        .doc(movieId.toString())
        .delete();
  }

  Future<List<MovieListModel>> getMovies({
    required String uid,
    required String listType,
  }) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('movieLists')
        .doc(listType)
        .collection('movies')
        .get();

    return snapshot.docs
        .map(
          (doc) => MovieListModel.fromJson(doc.data()),
        )
        .toList();
  }
}