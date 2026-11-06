
import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/contentful_shelf_service.dart';
import 'books_screen.dart';
import 'movies_screen.dart';
import 'pick_detail_screen.dart';

class MyShelfScreen extends StatelessWidget {
  const MyShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Picks'),
              Tab(text: 'Books'),
              Tab(text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksScreen(),
            BooksScreen(),
            MoviesScreen(),
          ],
        ),
      ),
    );
  }
}

class MyPicksScreen extends StatefulWidget {
  const MyPicksScreen({super.key});

  @override
  State<MyPicksScreen> createState() => _MyPicksScreenState();
}

class _MyPicksScreenState extends State<MyPicksScreen> {
  final ContentfulShelfService _service = ContentfulShelfService();

  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _loadPicks();
  }

  void _loadPicks() {
    _picksFuture = _service.fetchPicks();
  }

  Future<void> _refreshPicks() async {
    final future = _service.fetchPicks();

    setState(() {
      _picksFuture = future;
    });

    await future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _picksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Unable to load your picks.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final picks = snapshot.data ?? [];

        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshPicks,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(child: Text('No saved picks yet.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshPicks,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    pick.kind == 'book'
                        ? Icons.menu_book_rounded
                        : Icons.movie_rounded,
                  ),
                  title: Text(
                    pick.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${pick.kind.toUpperCase()}'
                    '${pick.note.isNotEmpty ? '\n${pick.note}' : ''}',
                  ),
                  isThreeLine: pick.note.isNotEmpty,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PickDetailScreen(pick: pick),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
