import 'package:flutter/material.dart';
import '../components/search_bar.dart';
import '../components/movie_list.dart';
import '../services/api.dart';
import 'movie_detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _movies = [];
  bool _showRandomMovies = true;
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _fetchRandomMovies();
  }

  void _fetchRandomMovies() async {
    try {
      final randomMovies = await ApiService.fetchRandomMovies();
      setState(() {
        _movies = randomMovies;
        _showRandomMovies = true;
      });
    } catch (e) {
      print('Error fetching random movies: $e');
    }
  }

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

  void _showMovieDetail(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Movie Search',
          style: TextStyle(
              fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: _toggleSearchBar,
          ),
        ],
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 0, // Remove elevation
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _showSearchBar
                ? MovieSearchBar(onMoviesFetched: _updateMovies)
                : SizedBox(height: 0),
          ),
          Expanded(
            child: _showRandomMovies
                ? FutureBuilder(
                    future: ApiService.fetchRandomMovies(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print(
                            'Error fetching random movies: ${snapshot.error}');
                        return Center(
                            child: Text('Failed to load random movies'));
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final List<dynamic> randomMovies = snapshot.data!;
                        if (randomMovies.isEmpty) {
                          return Center(child: Text('No movies available'));
                        }
                        return MovieList(
                          movies: randomMovies,
                          onMovieTap: _showMovieDetail,
                        );
                      } else {
                        return Center(child: Text('No movies available'));
                      }
                    },
                  )
                : _movies.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Movie not found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : MovieList(
                        movies: _movies,
                        onMovieTap: _showMovieDetail,
                      ),
          ),
        ],
      ),
    );
  }
}
