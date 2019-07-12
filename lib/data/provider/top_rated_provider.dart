abstract class TopRatedProvider {
  Future<List<String>> findAllByType(String type);

  Future<List<String>> insertAllByType(List<String> listOfId, String type);

  Future<bool> deleteAllByType(String type);
}
