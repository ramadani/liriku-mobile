import 'dart:convert';

import 'package:liriku/data/model/collection.dart';
import 'package:liriku/data/provider/api/http_client.dart';
import 'package:liriku/data/provider/collection_provider.dart';

class CollectionProviderApi implements CollectionProvider {
  final HttpClient _client;

  CollectionProviderApi(this._client);

  @override
  Future<List<Collection>> all() async {
    try {
      final response = await _client.auth().get('/collections');

      if (!_client.ok(response.statusCode)) {
        throw Exception(response.body);
      }

      final body = json.decode(response.body);
      final data = body['data'] as List;
      final List<Collection> results = data.map((raw) {
        return Collection(
          id: raw['id'],
          label: raw['label'],
          createdAt: DateTime.parse(raw['createdAt']),
        );
      }).toList();

      return results;
    } catch (e) {
      throw e;
    }
  }
}
