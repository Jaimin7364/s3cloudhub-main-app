import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/blog.dart';

/// Your Medium username (no @, no trailing dot)
const _username = 'S3CloudHub';

/// rss2json endpoint – converts Medium RSS to JSON to avoid CORS / UA issues
final _apiUrl = Uri.parse(
  'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@$_username',
);

/// Fetches Medium posts and maps them to [Blog] objects.
Future<List<Blog>> fetchMediumBlogs() async {
  final res = await http.get(_apiUrl);

  if (res.statusCode != 200) {
    throw Exception('Medium API responded with ${res.statusCode}');
  }

  final data = json.decode(res.body) as Map<String, dynamic>;
  final items = (data['items'] as List).cast<Map<String, dynamic>>();

  return items.map((item) {
    // rss2json gives ISO dates already
    final date = DateTime.parse(item['pubDate']);

    return Blog(
      title: item['title'] as String,
      link: item['link'] as String,
      pubDate: date,
      thumbnail: item['thumbnail'] as String? ?? '',
      description: item['description']
              ?.replaceAll(RegExp(r'<[^>]+>'), '')
              .trim() ?? '',
    );
  }).toList();
}
