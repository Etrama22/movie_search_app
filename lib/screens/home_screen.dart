import 'package:flutter/material.dart';
import '../components/search_bar.dart';
import '../components/navbar.dart';
import '../components/movie_list.dart';
import '../services/api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _movies = [];
  bool _showRandomMovies = true;
  bool _showSearchBar = false; // new variable to track search bar visibility

  void _updateMovies(List<dynamic> movies) {
    setState(() {
      _movies = movies;
      _showRandomMovies = false;
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      appBar: AppBar(
        title: Text('Movie Search',
            style: TextStyle(fontSize: 18, color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _toggleSearchBar, // toggle search bar visibility
          ),
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {}, // add your bookmark action here
          ),
        ],
        backgroundColor:
            Color.fromARGB(255, 2, 2, 2), // change the app bar color
      ),
      body: Column(
        children: [
          _showSearchBar
              ? MovieSearchBar(onMoviesFetched: _updateMovies)
              : Container(), // show search bar only when _showSearchBar is true
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
      bottomNavigationBar: Navbar(),
    );
  }
}
