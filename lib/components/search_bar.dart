import 'package:flutter/material.dart';
import '../services/api.dart';

class MovieSearchBar extends StatefulWidget {
  final Function(List<dynamic>) onMoviesFetched;

  MovieSearchBar({required this.onMoviesFetched});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<MovieSearchBar> {
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

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

  void _onSearchTextChanged() {
    if (_searchController.text.isEmpty) {
      // Jika teks dihapus, kembali menampilkan film acak
      widget.onMoviesFetched([]);
      setState(() {
        _isLoading = true; // Tampilkan loading indicator saat memuat film acak
      });
      _fetchRandomMovies();
    }
  }

  void _fetchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });

    final movies = await ApiService.fetchMovies(query);

    setState(() {
      _isLoading = false;
      if (movies.isEmpty) {
      } else {}
    });

    widget.onMoviesFetched(movies);
  }

  void _fetchRandomMovies() async {
    final movies = await ApiService.fetchRandomMovies();
    widget.onMoviesFetched(movies);
    setState(() {
      _isLoading =
          false; // Hilangkan loading indicator setelah selesai memuat film acak
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          25, 5, 25, 5), // add padding to avoid tight spacing
      margin: const EdgeInsets.all(
          16.0), // add margin to create space around the search bar
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.horizontal(
          // create semi-circular corner
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
        onChanged: _fetchMovies,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search for movies...',
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: _isLoading
              ? Container(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                )
              : _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
        ),
      ),
    );
  }
}
