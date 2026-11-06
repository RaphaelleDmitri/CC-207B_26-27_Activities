import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api_config.dart';
import 'api_exception.dart';

class OmdbApi {
  static const String _baseUrl = 'https://www.omdbapi.com/';

  Future<List<dynamic>> search(String query) async {
    if (omdbKey.isEmpty) {
      throw ApiException('OMDb API key is missing.');
    }

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'apikey': omdbKey,
        's': query,
        'type': 'movie',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException('Failed to connect to OMDb.');
    }

    final data = jsonDecode(response.body);

    if (data['Response'] == 'False') {
      final error = data['Error'] ?? 'Unknown OMDb error.';

      if (error == 'Movie not found!') {
        return [];
      }

      throw ApiException(error);
    }

    return data['Search'] ?? [];
  }

  Future<Map<String, dynamic>> getMovieDetails(String imdbId) async {
    if (omdbKey.isEmpty) {
      throw ApiException('OMDb API key is missing.');
    }

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'apikey': omdbKey,
        'i': imdbId,
        'plot': 'short',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException('Failed to load movie details.');
    }

    final data = jsonDecode(response.body);

    if (data['Response'] == 'False') {
      throw ApiException(
        data['Error'] ?? 'Movie details not found.',
      );
    }

    return data;
  }
}