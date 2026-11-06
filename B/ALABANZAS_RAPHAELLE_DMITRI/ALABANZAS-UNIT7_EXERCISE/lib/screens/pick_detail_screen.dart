
import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/open_library_service.dart';
import '../services/omdb_service.dart';

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({
    super.key,
    required this.pick,
  });

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  final OpenLibraryService _bookService = OpenLibraryService();
  final OmdbApi _movieService = OmdbApi();

  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    if (widget.pick.kind.toLowerCase() == 'book') {
      _detailsFuture =
          _bookService.getBookDetails(widget.pick.externalId);
    } else {
      _detailsFuture =
          _movieService.getMovieDetails(widget.pick.externalId);
    }
  }

  String _getBookDescription(dynamic description) {
    return switch (description) {
      String text => text,
      {'value': String text} => text,
      _ => 'No description available.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    final isBook = pick.kind.toLowerCase() == 'book';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load details.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final details = snapshot.data ?? {};

          final imageUrl = isBook
              ? (details['covers'] is List &&
                      (details['covers'] as List).isNotEmpty)
                  ? 'https://covers.openlibrary.org/b/id/${details['covers'][0]}-L.jpg'
                  : null
              : (details['Poster'] != null &&
                      details['Poster'] != 'N/A')
                  ? details['Poster'].toString()
                  : null;

          final summary = isBook
              ? _getBookDescription(details['description'])
              : details['Plot']?.toString() ??
                  'No plot summary available.';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  Center(
                    child: Image.network(
                      imageUrl,
                      height: 280,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          Icon(
                            isBook ? Icons.book : Icons.movie,
                            size: 100,
                          ),
                    ),
                  )
                else
                  Center(
                    child: Icon(
                      isBook ? Icons.book : Icons.movie,
                      size: 100,
                    ),
                  ),

                const SizedBox(height: 24),

                Text(
                  pick.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Text(
                  pick.note,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 24),

                const Divider(),

                Text(
                  'About this ${isBook ? 'book' : 'movie'}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Text(
                  summary,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
