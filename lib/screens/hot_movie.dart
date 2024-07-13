import 'package:flutter/material.dart';
import '../services/api.dart';
import 'movie_detail.dart';

// Kelas untuk menampilkan layar film populer
class HotMovieScreen extends StatefulWidget {
  @override
  _HotMovieScreenState createState() => _HotMovieScreenState();
}

// State untuk HotMovieScreen
class _HotMovieScreenState extends State<HotMovieScreen> {
  List<dynamic> _hotMovies = []; // Daftar untuk menyimpan film yang populer

  @override
  void initState() {
    super.initState();
    _fetchHotMovies(); // Memanggil fungsi untuk mengambil data film saat inisialisasi
  }

  // Fungsi untuk mengambil data film populer dari API
  void _fetchHotMovies() async {
    try {
      final hotMovies = await ApiService.fetchPopularMovies();
      setState(() {
        _hotMovies = hotMovies; // Memperbarui state dengan film yang diambil
      });
    } catch (e) {
      print(e); // Menampilkan error jika ada masalah saat pengambilan data
    }
  }

  // Fungsi untuk navigasi ke detail film
  void _navigateToDetail(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MovieDetailScreen(movie: movie), // Membuka layar detail film
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hot Movies'), // Judul AppBar
        backgroundColor: Colors.black, // Warna latar AppBar
        foregroundColor: Colors.white, // Warna teks AppBar
      ),
      body: _hotMovies.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Menampilkan spinner jika tidak ada data film
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Jumlah kolom dalam grid
                childAspectRatio: 0.7, // Rasio aspek tiap item
                mainAxisSpacing: 8.0, // Spasi vertikal antar item
                crossAxisSpacing: 8.0, // Spasi horizontal antar item
              ),
              itemCount: _hotMovies.length, // Jumlah total item dalam grid
              itemBuilder: (context, index) {
                final movie = _hotMovies[index]; // Film pada index tertentu
                return GestureDetector(
                  onTap: () =>
                      _navigateToDetail(movie), // Menangani ketukan pada item
                  child: Card(
                    elevation: 5, // Elevasi untuk shadow
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Border radius dari card
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                  10), // Radius untuk bagian atas gambar
                            ),
                            child: movie['poster_path'] != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w200${movie['poster_path']}', // URL gambar
                                    fit: BoxFit.cover, // Fit gambar
                                  )
                                : Container(
                                    color: Colors
                                        .grey, // Warna latar jika tidak ada gambar
                                    child: Icon(Icons.movie,
                                        size: 50), // Ikon default
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie['title'], // Judul film
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis, // Ellipsis untuk teks yang terlalu panjang
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Release Date: ${movie['release_date']}', // Tanggal rilis film
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis, // Ellipsis untuk teks yang terlalu panjang
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
