
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api_config.dart';
import '../services/omdb_service.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final OmdbApi _service = OmdbApi();
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  List<dynamic> _movies = [];
  bool _loading = false;
  String? _error;

  void _searchMovies(String query) {
    _debounce?.cancel();

    if (query.trim().length < 3) {
      setState(() {
        _movies = [];
        _loading = false;
        _error = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _loading = true;
        _error = null;
      });

      try {
final results = await _service.search(query.trim());
        if (!mounted) return;

        setState(() {
          _movies = results;
          _loading = false;
        });
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    });
  }

  void _copyMovieId(String imdbId) {
    Clipboard.setData(ClipboardData(text: imdbId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied IMDb ID: $imdbId')),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'OMDb API key is missing.\n\n'
            'Please configure your OMDB_KEY and run Flutter with:\n'
            'flutter run --dart-define-from-file=secrets.json',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            onChanged: _searchMovies,
            decoration: const InputDecoration(
              hintText: 'Search movies...',
              prefixIcon: Icon(Icons.movie_outlined),
              border: OutlineInputBorder(),
            ),
          ),
        ),

        if (_loading)
          const CircularProgressIndicator()
        else if (_error != null)
          Text(_error!)
        else if (_controller.text.trim().length < 3)
          const Text('Search for a movie (at least 3 characters).')
        else if (_movies.isEmpty)
          const Text('Nothing found.')
        else
          Expanded(
            child: ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];

                final imdbId = movie['imdbID']?.toString() ?? '';
                final poster = movie['Poster'];

                return ListTile(
                  leading: poster != null && poster != 'N/A'
                      ? Image.network(
                          poster,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.movie),
                        )
                      : const Icon(Icons.movie),

                  title: Text(movie['Title'] ?? 'Unknown title'),

                  subtitle: Text(movie['Year'] ?? 'Unknown year'),

                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy IMDb ID',
                    onPressed: imdbId.isEmpty
                        ? null
                        : () => _copyMovieId(imdbId),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
