import 'dart:convert';

import 'package:liriku/data/collection/artist_collection.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/provider/api/http_client.dart';
import 'package:liriku/data/provider/artist_provider.dart';

class ArtistProviderApi implements ArtistProvider {
  final HttpClient _client;

  ArtistProviderApi(this._client);

  @override
  Future<ArtistCollection> fetch(int page, int perPage,
      {String search = ""}) async {
    final uri = Uri(path: '/artists', queryParameters: {
      'page': page.toString(),
      'perPage': perPage.toString(),
      'search': search,
    });
    final response = await _client.auth().get(uri);

    if (!_client.ok(response.statusCode)) {
      throw Exception(response.body);
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List;
    final List<Artist> artists = List();

    artists.addAll(data.map((raw) => _artistMapper(raw)).toList());

    return ArtistCollection(
      artists,
      body['meta']['page'] as num,
      body['meta']['perPage'] as num,
    );
  }

  @override
  Future<List<Artist>> topByNewLyric(int limit) async {
    final uri = Uri(
      path: '/artists/top',
      queryParameters: {'limit': limit.toString()},
    );
    final response = await _client.auth().get(uri);

    if (!_client.ok(response.statusCode)) {
      throw Exception(response.body);
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List;
    final List<Artist> results = List();

    results.addAll(data.map((raw) => _artistMapper(raw)).toList());

    return results;
  }

  @override
  Future<ArtistLyrics> detail(String id) async {
    final response = await _client.auth().get('/artists/$id');

    if (!_client.ok(response.statusCode)) {
      throw Exception(response.body);
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final List<Lyric> lyrics = List();

    lyrics.addAll((data['lyrics'] as List)
        .map((raw) => _lyricMapper(raw, data['id']))
        .toList());

    return ArtistLyrics(
      id: data['id'],
      name: data['name'],
      coverUrl: data['coverImgUrl'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      lyrics: lyrics,
    );
  }

  Artist _artistMapper(dynamic raw) {
    return Artist(
      id: raw['id'],
      name: raw['name'],
      coverUrl: raw['coverImgUrl'],
      createdAt: DateTime.parse(raw['createdAt']),
      updatedAt: DateTime.parse(raw['updatedAt']),
    );
  }

  Lyric _lyricMapper(dynamic raw, String artistId) {
    return Lyric(
      id: raw['id'],
      title: raw['title'],
      coverUrl: raw['coverImgUrl'],
      readCount: raw['readCount'] as num,
      content: raw['content'],
      artistId: artistId,
      createdAt: DateTime.parse(raw['createdAt']),
      updatedAt: DateTime.parse(raw['updatedAt']),
    );
  }
}
