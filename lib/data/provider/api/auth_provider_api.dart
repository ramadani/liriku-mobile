import 'dart:convert';

import 'package:liriku/data/model/auth.dart';
import 'package:liriku/data/provider/api/http_client.dart';
import 'package:liriku/data/provider/auth_provider.dart';

class AuthProviderApi implements AuthProvider {
  final HttpClient _client;

  AuthProviderApi(this._client);

  @override
  Future<Auth> create(String deviceName) async {
    final response = await _client.guest().post(
      '/auth',
      body: {'deviceName': deviceName},
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    if (!_client.ok(response.statusCode)) {
      throw Exception(response.body);
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final result = Auth(
      deviceName: data['deviceName'],
      token: data['token'],
      createdAt: DateTime.parse(data['createdAt']),
    );

    return result;
  }
}
