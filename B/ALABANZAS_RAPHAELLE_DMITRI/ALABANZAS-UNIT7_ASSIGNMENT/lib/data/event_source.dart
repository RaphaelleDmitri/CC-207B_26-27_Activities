import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/fair_event.dart';

// EXPLAIN E1: The screens only know this interface. They never import
// strapi_source.dart or contentful_source.dart. What would you have to change
// to move the app from one CMS to another, and what would stay the same?
/*
  1. Change the import of the CMS source (e.g., from strapi_source.dart to contentful_source.dart).
  2. Update the instantiation of the EventSource implementation in the main application code (e.g., replace StrapiEventSource with ContentfulEventSource).
  3. Ensure that any CMS-specific configuration (like API keys, space IDs, etc.) is updated accordingly.
 */
abstract interface class EventSource {
  /// Shown in the drawer, e.g. 'Strapi'.
  String get name;

  Future<List<FairEvent>> fetchEvents();
}

/// A problem the user should read: no internet, wrong token, and so on.
class CmsException implements Exception {
  const CmsException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Sends a GET request and gives back the decoded JSON.
/// Every CMS source uses it, so the error messages are the same everywhere.
Future<Object?> getJson(
  http.Client client,
  Uri uri, {
  required String cms,
  Map<String, String> headers = const {},
}) async {
  final http.Response response;
  try {
    response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw CmsException('$cms took too long to answer. Try again.');
  } on http.ClientException {
    throw const CmsException(
      'No connection. Check your internet and try again.',
    );
  }
  return decodeOrThrow(response, cms);
}

/// Turns an HTTP answer into JSON, or into a message the user can act on.
Object? decodeOrThrow(http.Response response, String cms) {
  final code = response.statusCode;

  switch (code) {
    case 200:
      return jsonDecode(response.body);

    case 401 || 403:
      throw CmsException(
        '$cms refused the request ($code). Check your token and the read permission.',
      );

    case 404:
      throw CmsException(
        '$cms could not find the events (404). Check the URL and the content type name.',
      );

    case >= 500:
      throw CmsException(
        '$cms is having problems ($code). Try again later.',
      );

    default:
      throw CmsException('$cms answered $code.');
  }
}
  // EXPLAIN E4: 401, 404 and 500 are all "errors", but who has to fix each
  // one: the user, you (the developer), or the people running the CMS?

  /*
  A 401 error usually means that the authentication token is missing or invalid, 
  so the developer or administrator must check the credentials. 
  A 404 error means that the requested resource cannot be found, which is usually caused by an incorrect API URL or content type identifier that the developer must fix.
  A 500 error indicates an internal server problem, which normally needs to be resolved by the CMS provider. 
  These different error messages help identify who is responsible for resolving the issue.
   */
  // TODO 1: Use a switch on code:
  //   200        -> return jsonDecode(response.body)
  //   401 or 403 -> throw CmsException('$cms refused the request ($code). Check your token and the read permission.')
  //   404        -> throw CmsException('$cms could not find the events (404). Check the URL and the content type name.')
  //   500 and up -> throw CmsException('$cms is having problems ($code). Try again later.')
  //   anything else -> throw CmsException('$cms answered $code.')
  // Hint: patterns like `case 401 || 403:` and `case >= 500:` work in Dart 3.
