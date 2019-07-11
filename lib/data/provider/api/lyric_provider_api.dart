import 'dart:convert';

import 'package:liriku/data/collection/lyric_collection.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/provider/api/http_client.dart';
import 'package:liriku/data/provider/lyric_provider.dart';

class LyricProviderApi implements LyricProvider {
  final HttpClient _client;

  LyricProviderApi(this._client);

  @override
  Future<LyricCollection> fetch(int page, int perPage,
      {String search = ""}) async {
    final uri = Uri(path: '/lyrics', queryParameters: {
      'page': page,
      'perPage': perPage,
      'search': search,
    });
    final response = await _client.auth().get(uri);

    if (!_client.ok(response.statusCode)) {
      throw Exception(response.body);
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List;
    final List<Lyric> lyrics = data.map((raw) => _lyricMapper(raw)).toList();

    return LyricCollection(
      lyrics,
      body['meta']['page'] as num,
      body['meta']['perPage'] as num,
    );
  }

  @override
  Future<List<Lyric>> topNew(int limit) async {
    final uri = Uri(path: '/lyrics/top', queryParameters: {'limit': limit});
    final response = await _client.auth().get(uri);

    if (!_client.ok(response.statusCode)) {
      throw Exception(response.body);
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List;
    final List<Lyric> results = data.map((raw) => _lyricMapper(raw)).toList();

    return results;
  }

  Lyric _lyricMapper(dynamic raw) {
    final artistRaw = raw['artist'];

    return LyricArtist(
      id: raw['id'],
      title: raw['title'],
      coverUrl: raw['coverImgUrl'],
      readCount: raw['readCount'] as num,
      content: raw['content'],
      createdAt: DateTime.parse(raw['createdAt']),
      updatedAt: DateTime.parse(raw['updatedAt']),
      artist: Artist(
        id: artistRaw['id'],
        name: artistRaw['name'],
        createdAt: DateTime.parse(artistRaw['createdAt']),
        updatedAt: DateTime.parse(artistRaw['updatedAt']),
      ),
    );
  }
}
