import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/movie_list_model.dart';

class MovieListCard extends StatelessWidget {
  final MovieListModel movie;
  final VoidCallback onDelete;

  const MovieListCard({
    super.key,
    required this.movie,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl:
                  'https://image.tmdb.org/t/p/w200${movie.posterPath}',
              width: 90,
              height: 120,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return const SizedBox(
                  width: 90,
                  height: 120,
                  child: Icon(Icons.error),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}