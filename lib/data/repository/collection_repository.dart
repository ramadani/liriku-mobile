import 'package:liriku/data/model/collection.dart';

abstract class CollectionRepository {
  Future<List<Collection>> all();
}