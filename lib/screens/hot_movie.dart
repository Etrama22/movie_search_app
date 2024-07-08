import 'package:flutter/material.dart';
import '../services/apiV2.dart';
import '../components/navbar.dart';

class HotMovieScreen extends StatefulWidget {
  @override
  _HotMovieScreenState createState() => _HotMovieScreenState();
}

class _HotMovieScreenState extends State<HotMovieScreen> {
  List<dynamic> _hotMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchHotMovies();
  }

  void _fetchHotMovies() async {
    try {
      final hotMovies = await ApiService.fetchPopularMovies();
      setState(() {
        _hotMovies = hotMovies;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hot Movies'),
      ),
      body: _hotMovies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _hotMovies.length,
              itemBuilder: (context, index) {
                final movie = _hotMovies[index];
                return ListTile(
                  title: Text(movie['title']),
                  subtitle: Text('Release Date: ${movie['release_date']}'),
                  leading: movie['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w200${movie['poster_path']}')
                      : null,
                );
              },
            ),
      bottomNavigationBar: Navbar(),
    );
  }
}
