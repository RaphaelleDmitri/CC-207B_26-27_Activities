
import 'package:http/http.dart' as http;

import '../../models/fair_event.dart';
import '../event_source.dart';

/// Contentful (hosted headless CMS), Content Delivery API.
///
/// Content model: "Fair Event" with the API identifier fairEvent.
/// Fields: title, orgId, startsAt, venue, description, cancelled.
class ContentfulEventSource implements EventSource {
  ContentfulEventSource(
    this.client, {
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;
  final String token;
  final String environment;

  @override
  String get name => 'Contentful';

  @override
  Future<List<FairEvent>> fetchEvents() async {
    // TODO 2: Build the Contentful API request.
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {
        'content_type': 'fairEvent',
        'order': 'fields.startsAt',
        'limit': '100',
      },
    );

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    final response = await getJson(
      client,
      uri,
      cms: name,
      headers: headers,
    );

    // TODO 3: Convert Contentful JSON into FairEvent objects.
    if (response is! Map<String, dynamic>) {
      throw CmsException('$name returned an invalid response.');
    }

    final items = response['items'] as List<dynamic>? ?? [];

    return items.map((item) {
      final fields = item['fields'] as Map<String, dynamic>;
      final sys = item['sys'] as Map<String, dynamic>;

      return FairEvent(
        id: sys['id'] as String,
        orgId: fields['orgId'] as String? ?? '',
        title: fields['title'] as String? ?? '',
        startsAt: DateTime.tryParse(
              fields['startsAt'] as String? ?? '',
            ) ??
            DateTime(1970),
        venue: fields['venue'] as String? ?? '',
        description: fields['description'] as String? ?? '',
        cancelled: fields['cancelled'] as bool? ?? false,
      );
    }).toList();
  }
}
