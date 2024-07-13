import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = 'b1db52933cd9d5126ba2dd8a41084128';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<dynamic>> fetchPopularMovies() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> moviesJson = data['results'];
      return moviesJson;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<dynamic>> fetchRandomMovies() async {
    int randomPage =
        Random().nextInt(100) + 1; // Ubah limit halaman sesuai kebutuhan API

    final response = await http.get(Uri.parse(
        '$_baseUrl/discover/movie?api_key=$_apiKey&page=$randomPage'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> moviesJson = data['results'];
      return moviesJson;
    } else {
      throw Exception('Failed to load random movies');
    }
  }

  static Future<List<dynamic>> fetchMovies(String query) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=$query'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> moviesJson = data['results'];
      return moviesJson;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
