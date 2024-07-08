import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = 'b1db52933cd9d5126ba2dd8a41084128';
  static const String _baseUrl = 'https://api.themoviedb.org/3/movie/popular';

  static Future<List<dynamic>> fetchPopularMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> moviesJson = data['results'];
      return moviesJson;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
