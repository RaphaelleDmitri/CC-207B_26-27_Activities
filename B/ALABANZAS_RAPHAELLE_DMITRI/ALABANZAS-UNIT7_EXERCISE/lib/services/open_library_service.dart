
import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenLibraryService {
  static const String _baseUrl = 'https://openlibrary.org';

  Future<List<dynamic>> searchBooks(String query) async {
    final uri = Uri.parse('$_baseUrl/search.json').replace(
      queryParameters: {
        'q': query,
        'fields': 'key,title,author_name,first_publish_year,cover_i',
        'limit': '20',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to search books.');
    }

    final data = jsonDecode(response.body);

    return data['docs'] ?? [];
  }

  Future<Map<String, dynamic>> getBookDetails(String workId) async {
    final uri = Uri.parse('$_baseUrl/works/$workId.json');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load book details.');
    }

    return jsonDecode(response.body);
  }

  String? getCoverUrl(dynamic coverId) {
    if (coverId == null) return null;

    return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
  }
}
