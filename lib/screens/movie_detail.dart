import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Kelas untuk menampilkan detail film
class MovieDetailScreen extends StatelessWidget {
  final dynamic movie; // Variabel untuk menyimpan detail film

  // Konstruktor dengan parameter movie yang diperlukan
  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    // Membangun tampilan detail film
    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie['title'] ?? 'Movie Details', // Judul film atau teks default
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan poster film jika tersedia
            if (movie['poster_path'] != null)
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Posisi bayangan
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            // Menampilkan judul film
            Text(
              movie['title'] ?? 'No Title',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            // Menampilkan tanggal rilis film
            Text(
              'Release Date: ${movie['release_date'] ?? 'Unknown'}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.0),
            Divider(),
            SizedBox(height: 8.0),
            // Menampilkan judul bagian sinopsis
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            // Menampilkan sinopsis film
            Text(
              movie['overview'] ?? 'No overview available.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.0),
            // Menampilkan rating film jika tersedia
            if (movie['vote_average'] != null)
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 24.0,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    movie['vote_average'].toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            // Menampilkan tombol aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.bookmark_border),
                  onPressed: () {
                    _addToBookmark(context); // Menambahkan ke bookmark
                  },
                ),
                IconButton(
                  icon: Icon(Icons.link),
                  onPressed: () {
                    final url =
                        'https://www.themoviedb.org/movie/${movie['id']}';
                    _launchURL(url); // Membuka URL
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    final url =
                        'https://www.themoviedb.org/movie/${movie['id']}';
                    Share.share(
                        'Check out this movie: ${movie['title']} $url'); // Berbagi URL
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menambahkan film ke bookmark
  void _addToBookmark(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to bookmark')),
      );
      return;
    }

    final CollectionReference bookmarks = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('bookmarks');

    try {
      await bookmarks.add({
        'title': movie['title'] ?? '',
        'poster_path': movie['poster_path'] ?? '',
        'overview': movie['overview'] ?? '',
        'release_date': movie['release_date'] ?? '',
        // tambahkan data lainnya yang ingin Anda simpan
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to bookmarks')),
      );
    } catch (e) {
      print('Error adding to bookmarks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to bookmarks')),
      );
    }
  }

  // Fungsi untuk membuka URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
