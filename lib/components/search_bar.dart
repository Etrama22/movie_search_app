import 'package:flutter/material.dart';
import '../services/api.dart';

// Widget untuk bilah pencarian film
class MovieSearchBar extends StatefulWidget {
  final Function(List<dynamic>) onMoviesFetched;

  // Konstruktor dengan fungsi callback untuk hasil pencarian
  MovieSearchBar({required this.onMoviesFetched});

  @override
  _MovieSearchBarState createState() => _MovieSearchBarState();
}

class _MovieSearchBarState extends State<MovieSearchBar> {
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  int _searchResultCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi yang dipanggil saat teks pencarian berubah
  void _onSearchTextChanged() {
    if (_searchController.text.isEmpty) {
      widget.onMoviesFetched([]);
      setState(() {
        _isLoading = true;
      });
      _fetchRandomMovies();
    }
  }

  // Fungsi untuk mengambil film berdasarkan query
  void _fetchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await ApiService.fetchMovies(query);
      setState(() {
        _isLoading = false;
        _searchResultCount = movies.length;
      });
      widget.onMoviesFetched(movies);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _searchResultCount = 0;
      });
      print('Error fetching movies: $e');
    }
  }

  // Fungsi untuk mengambil film secara acak
  void _fetchRandomMovies() async {
    try {
      final movies = await ApiService.fetchRandomMovies();
      setState(() {
        _isLoading = false;
      });
      widget.onMoviesFetched(movies);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching random movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(50.0),
              right: Radius.circular(50.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (query) {
              if (query.isNotEmpty) {
                _fetchMovies(query);
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search for movies...',
              hintStyle: TextStyle(color: Colors.grey),
              suffixIcon: _isLoading
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    )
                  : _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            widget.onMoviesFetched([]);
                            setState(() {
                              _searchResultCount = 0;
                            });
                          },
                        )
                      : null,
            ),
          ),
        ),
        _searchResultCount > 0
            ? Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 16, 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Found $_searchResultCount movies',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
