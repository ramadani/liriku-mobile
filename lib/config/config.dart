import 'config_data.dart';

abstract class Config {
  Future<void> loadFromAssets(String filename);

  ConfigData data();

  AdUnitId adUnitId();
}
