
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';
import '../services/open_library_api.dart';
import '../services/open_library_service.dart';
import 'book_details_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final OpenLibraryApi _api = OpenLibraryApi();
  final OpenLibraryService _service = OpenLibraryService();
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  Future<List<Book>>? _searchFuture;
  bool _waitingForDebounce = false;

  void _searchBooks(String query) {
    _debounce?.cancel();

    if (query.trim().length < 3) {
      setState(() {
        _searchFuture = null;
        _waitingForDebounce = false;
      });
      return;
    }

    setState(() {
      _searchFuture = null;
      _waitingForDebounce = true;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _waitingForDebounce = false;
        _searchFuture = _api.search(query.trim());
      });
    });
  }

  void _copyBookId(String workId) {
    Clipboard.setData(ClipboardData(text: workId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied Book ID: $workId')),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            onChanged: _searchBooks,
            decoration: const InputDecoration(
              hintText: 'Search books...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),

        if (_controller.text.trim().length < 3)
          const Text('Search for a book (at least 3 characters).')
        else if (_waitingForDebounce)
          const CircularProgressIndicator()
        else if (_searchFuture != null)
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _searchFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final books = snapshot.data ?? [];

                if (books.isEmpty) {
                  return const Center(
                    child: Text('Nothing found.'),
                  );
                }

                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final coverUrl =
                        _service.getCoverUrl(book.coverId);

                    final author = book.authors.isNotEmpty
                        ? book.authors.first
                        : 'Unknown author';

                    return ListTile(
                      leading: coverUrl != null
                          ? Image.network(
                              coverUrl,
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.book),
                            )
                          : const Icon(Icons.book),

                      title: Text(book.title),

                      subtitle: Text(
                        '$author${book.year != null ? ' • ${book.year}' : ''}',
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy Book ID',
                        onPressed: () =>
                            _copyBookId(book.workId),
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookDetailsScreen(
                              workId: book.workId,
                              title: book.title,
                              author: author,
                              year: book.year,
                              coverId: book.coverId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
