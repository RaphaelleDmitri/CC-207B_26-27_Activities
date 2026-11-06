
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'pick_source.dart';

class ContentfulShelfService implements PickSource {
  static const String _spaceId =
      String.fromEnvironment('CMS_SPACE');

  static const String _token =
      String.fromEnvironment('CMS_TOKEN');

  static const String _environment = 'master';

  @override
  Future<List<Pick>> fetchPicks() async {
    if (_spaceId.isEmpty || _token.isEmpty) {
      throw Exception('Contentful configuration is missing.');
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$_spaceId/environments/$_environment/entries',
      {
        'content_type': 'shelfPick',
        'limit': '100',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Contentful error: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);
    final items = data['items'] as List;

    return items.map<Pick>((item) {
      final fields = item['fields'] as Map<String, dynamic>;

      dynamic getField(String name) {
        final value = fields[name];

        if (value is Map) {
          return value.values.first;
        }

        return value;
      }

      return Pick(
        id: item['sys']['id'],
        title: getField('title') ?? 'Untitled',
        kind: getField('kind') ?? '',
        externalId: getField('externalId') ?? '',
        note: getField('note') ?? '',
      );
    }).toList();
  }
}
