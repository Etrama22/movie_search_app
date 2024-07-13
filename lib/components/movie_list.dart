import 'package:flutter/material.dart';
import 'movie_card.dart';

/// Widget untuk menampilkan daftar film dalam bentuk grid.
class MovieList extends StatelessWidget {
  /// Daftar film yang akan ditampilkan.
  final List<dynamic> movies;

  /// Fungsi yang dipanggil ketika sebuah film diklik.
  final Function(dynamic) onMovieTap;

  /// Konstruktor untuk [MovieList].
  MovieList({required this.movies, required this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan lebar layar untuk menentukan jumlah kolom dalam grid.
    double screenWidth = MediaQuery.of(context).size.width;
    // Menentukan jumlah kolom berdasarkan lebar layar.
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    // Menentukan rasio aspek untuk setiap item dalam grid.
    double childAspectRatio = screenWidth > 600 ? 0.6 : 0.6;

    // Membuat GridView untuk menampilkan kartu film.
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        // Membuat kartu film untuk setiap film dalam daftar.
        return MovieCard(
          movie: movies[index],
          onTap: onMovieTap,
        );
      },
    );
  }
}
