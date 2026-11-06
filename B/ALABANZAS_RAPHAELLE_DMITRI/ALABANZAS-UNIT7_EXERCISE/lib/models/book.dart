class Book {
  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  const Book({
    required this.workId,
    required this.title,
    this.authors = const [],
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      workId: (json['key'] as String).split('/').last,
      title: json['title'] ?? 'Untitled',
      authors: List<String>.from(json['author_name'] ?? []),
      year: json['first_publish_year'],
      coverId: json['cover_i'],
    );
  }
}