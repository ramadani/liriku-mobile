import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:liriku/data/provider/auth_data_provider.dart';

class HttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthDataProvider _authDataProvider;
  final String _baseUrl;
  final String _apiKey;
  bool _isAuth = false;

  HttpClient(this._baseUrl, this._apiKey, this._authDataProvider);

  HttpClient guest() {
    _isAuth = false;
    return this;
  }

  HttpClient auth() {
    _isAuth = true;
    return this;
  }

  @override
  Future<http.Response> get(url, {Map<String, String> headers}) async {
    return super.get('$_baseUrl$url', headers: headers);
  }

  @override
  Future<http.Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return super.post('$_baseUrl$url',
        headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['x-api-key'] = _apiKey;
    if (_isAuth) {
      final authToken = await _authDataProvider.getToken();
      request.headers['auth-token'] = authToken;
    }

    return _inner.send(request);
  }

  bool ok(int statusCode) => statusCode >= 200 && statusCode <= 299;
}
