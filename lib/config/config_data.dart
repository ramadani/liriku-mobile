import 'package:meta/meta.dart';

class ConfigData {
  final bool debug;
  final String baseApiUrl;
  final String apiKey;
  final String admobAppId;
  final AdUnitId adUnitId;

  ConfigData({
    @required this.debug,
    @required this.baseApiUrl,
    @required this.apiKey,
    @required this.admobAppId,
    @required this.adUnitId,
  });
}

class AdUnitId {
  final String itemList;

  AdUnitId({this.itemList});
}
