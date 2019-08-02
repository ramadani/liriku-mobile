import 'package:liriku/data/model/collection.dart';

abstract class CollectionProvider {
  Future<List<Collection>> all();
}