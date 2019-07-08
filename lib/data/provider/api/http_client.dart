import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final String _baseUrl;
  final String _apiKey;
  bool _isAuth = false;

  HttpClient(this._baseUrl, this._apiKey);

  HttpClient guest() {
    _isAuth = false;
    return this;
  }

  HttpClient auth() {
    _isAuth = true;
    return this;
  }

  @override
  Future<http.Response> get(url, {Map<String, String> headers}) {
    return super.get('$_baseUrl$url', headers: headers);
  }

  @override
  Future<http.Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return super.post('$_baseUrl$url',
        headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['x-api-key'] = _apiKey;
    if (_isAuth) {
      request.headers['auth-token'] = '12345';
    }

    return _inner.send(request);
  }

  bool ok(int statusCode) => statusCode >= 200 && statusCode <= 299;
}
