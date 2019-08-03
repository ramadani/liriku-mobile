import 'package:liriku/data/model/collection.dart';

abstract class CollectionRepository {
  Future<bool> sync();

  Future<bool> needSync();

  Future<List<Collection>> all();
}
