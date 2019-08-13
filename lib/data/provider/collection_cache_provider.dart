import 'package:liriku/data/model/collection.dart';
import 'package:liriku/data/provider/collection_provider.dart';

abstract class CollectionCacheProvider extends CollectionProvider {
  Future<bool> save(Collection collection);

  Future<int> total();
}
