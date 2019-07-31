abstract class BookmarkableProvider {
  Future<List<String>> findIn(
      List<String> listOfBookmarkableId, String bookmarkableType);

  Future<bool> insert(String bookmarkableId, String bookmarkableType);

  Future<bool> delete(String bookmarkableId, String bookmarkableType);
}
