import 'package:flutter/material.dart';
import 'movie_card.dart';

class MovieList extends StatelessWidget {
  final List<dynamic> movies;
  final Function(dynamic) onMovieTap;

  MovieList({required this.movies, required this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    double childAspectRatio = screenWidth > 600 ? 0.6 : 0.6;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        return MovieCard(
          movie: movies[index],
          onTap: onMovieTap,
        );
      },
    );
  }
}
