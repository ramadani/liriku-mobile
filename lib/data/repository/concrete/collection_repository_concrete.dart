import 'package:liriku/data/model/collection.dart';
import 'package:liriku/data/provider/collection_provider.dart';
import 'package:liriku/data/repository/collection_repository.dart';

class CollectionRepositoryConcrete implements CollectionRepository {
  final CollectionProvider _collectionProvider;

  CollectionRepositoryConcrete(this._collectionProvider);

  @override
  Future<List<Collection>> all() async {
    try {
      final results = await _collectionProvider.all();

      return results;
    } catch (e) {
      throw e;
    }
  }
}