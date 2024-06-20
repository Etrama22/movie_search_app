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
  bool _noResults = false;

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
        _noResults = false;
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
        _noResults = true;
      } else {
        _noResults = false;
      }
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: _fetchMovies, // Pencarian dilakukan saat teks berubah
        decoration: InputDecoration(
          hintText: 'Search for movies...',
          suffixIcon: _isLoading
              ? CircularProgressIndicator()
              : _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null, // Tidak menampilkan ikon clear saat field kosong
        ),
      ),
    );
  }
}
