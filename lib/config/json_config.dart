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
      admobAppId: data['admob_app_id'],
      adUnitId: AdUnitId(
        itemList: data['ad_unit_id']['item_list'],
      ),
    );
  }

  @override
  ConfigData data() {
    return _data;
  }

  @override
  AdUnitId adUnitId() {
    return _data.adUnitId;
  }
}
