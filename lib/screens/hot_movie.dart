import 'package:flutter/material.dart';
import '../services/api.dart';
import 'movie_detail.dart';

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

  void _navigateToDetail(dynamic movie) {
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
      appBar: AppBar(
        title: Text('Hot Movies'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _hotMovies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: _hotMovies.length,
              itemBuilder: (context, index) {
                final movie = _hotMovies[index];
                return GestureDetector(
                  onTap: () => _navigateToDetail(movie),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            child: movie['poster_path'] != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey,
                                    child: Icon(Icons.movie, size: 50),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Release Date: ${movie['release_date']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
