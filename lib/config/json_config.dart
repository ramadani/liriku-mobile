import 'dart:convert';

import 'package:flutter/services.dart';

import 'config.dart';
import 'config_data.dart';

class JsonConfig extends Config {
  ConfigData _data;

  @override
  Future<void> loadFromAssets(String filename) async {
    final content = await rootBundle.loadString("assets/$filename");
    final data = jsonDecode(content);

    _data = ConfigData(
      baseApiUrl: data['base_api_url'],
      apiKey: data['api_key'],
    );
  }

  @override
  ConfigData data() {
    return _data;
  }
}
