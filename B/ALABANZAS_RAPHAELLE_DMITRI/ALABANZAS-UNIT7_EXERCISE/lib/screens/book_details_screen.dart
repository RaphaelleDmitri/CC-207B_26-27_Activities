
import 'package:flutter/material.dart';
import '../services/open_library_service.dart';

class BookDetailsScreen extends StatefulWidget {
  final String workId;
  final String title;
  final String author;
  final int? year;
  final int? coverId;

  const BookDetailsScreen({
    super.key,
    required this.workId,
    required this.title,
    required this.author,
    this.year,
    this.coverId,
  });

  @override
  State<BookDetailsScreen> createState() =>
      _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final OpenLibraryService _service = OpenLibraryService();

  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _service.getBookDetails(widget.workId);
  }

  String _description(dynamic description) {
    if (description is String) return description;
    if (description is Map) {
      return description['value']?.toString() ?? 'No description available.';
    }
    return 'No description available.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final book = snapshot.data ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.coverId != null)
                  Image.network(
                    _service.getCoverUrl(widget.coverId)!,
                    height: 220,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.book, size: 100),
                  ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(widget.author),
                if (widget.year != null)
                  Text('First published: ${widget.year}'),
                const Divider(height: 32),
                Text(
                  _description(book['description']),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
