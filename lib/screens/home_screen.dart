import 'package:flutter/material.dart';
import '../components/search_bar.dart';
import '../components/movie_list.dart';
import '../services/api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _movies = [];
  bool _showRandomMovies = true;

  void _updateMovies(List<dynamic> movies) {
    setState(() {
      _movies = movies;
      _showRandomMovies = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Search'),
      ),
      body: Column(
        children: [
          MovieSearchBar(onMoviesFetched: _updateMovies),
          _showRandomMovies
              ? Expanded(
                  child: FutureBuilder(
                    future: ApiService.fetchRandomMovies(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Failed to load random movies'));
                      } else {
                        final List<dynamic> randomMovies = snapshot.data ?? [];
                        return MovieList(movies: randomMovies);
                      }
                    },
                  ),
                )
              : _movies.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Movie not found',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Expanded(
                      child: MovieList(movies: _movies),
                    ),
        ],
      ),
    );
  }
}
