import 'package:liriku/data/model/collection.dart';
import 'package:liriku/data/provider/collection_cache_provider.dart';
import 'package:liriku/data/provider/collection_provider.dart';
import 'package:liriku/data/repository/collection_repository.dart';

class CollectionRepositoryConcrete implements CollectionRepository {
  final CollectionProvider _collectionProvider;
  final CollectionCacheProvider _collectionCacheProvider;

  CollectionRepositoryConcrete(
      this._collectionProvider, this._collectionCacheProvider);

  @override
  Future<bool> sync() async {
    try {
      final items = await _collectionProvider.all();
      await Future.forEach(items, (Collection it) async {
        await _collectionCacheProvider.save(it);
      });

      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> needSync() async {
    try {
      final total = await _collectionCacheProvider.total();

      return total == 0;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Collection>> all() async {
    try {
      final results = await _collectionCacheProvider.all();

      return results;
    } catch (e) {
      throw e;
    }
  }
}
