import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class ApiService {
  static const String _apiKey = '9efb7262';
  static const String _baseUrl = 'http://www.omdbapi.com/';

  static Future<List<dynamic>> fetchMovies(String query) async {
    final response =
        await http.get(Uri.parse('$_baseUrl?s=$query&apikey=$_apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['Search'] ?? [];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<dynamic>> fetchRandomMovies() async {
    final randomQueries = [
      'batman',
      'uperman',
      'harry potter',
      'avengers',
      'joker'
    ];
    final random = Random();
    final query = randomQueries[random.nextInt(randomQueries.length)];

    return await fetchMovies(query);
  }
}
