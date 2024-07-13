import 'package:flutter/material.dart';

// Widget untuk menampilkan kartu film
class MovieCard extends StatelessWidget {
  // Properti movie untuk menyimpan data film
  final dynamic movie;
  // Fungsi onTap untuk menangani ketukan pada kartu
  final Function(dynamic) onTap;

  // Konstruktor MovieCard yang memerlukan movie dan onTap
  MovieCard({
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan GestureDetector untuk mendeteksi ketukan
    return GestureDetector(
      onTap: () => onTap(movie),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan gambar poster jika tersedia
            if (movie['poster_path'] != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan judul film
                  Text(
                    movie['title'] ?? 'No Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8.0),
                  // Menampilkan tanggal rilis film
                  Text(
                    'Release Date: ${movie['release_date'] ?? 'Unknown'}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 8.0),
                  // Menampilkan rating film
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20.0,
                      ),
                      Text(
                        movie['vote_average']?.toString() ?? 'N/A',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
