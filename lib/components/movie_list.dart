import 'package:flutter/material.dart';
import 'movie_card.dart';

class MovieList extends StatelessWidget {
  final List<dynamic> movies;

  MovieList({required this.movies});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan lebar layar
    double screenWidth = MediaQuery.of(context).size.width;
    // Menentukan jumlah kolom berdasarkan lebar layar
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    // Menentukan aspect ratio berdasarkan jumlah kolom
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
        return MovieCard(movie: movies[index]);
      },
    );
  }
}
