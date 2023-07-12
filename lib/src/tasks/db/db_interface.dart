abstract class DBInterface {
  Future<void> insert(Map<String, dynamic> item);
  Future<void> remove(int id);
  Future<void> update(Map<String, dynamic> updatedItem);
  Future<List<Map<String, dynamic>>> list();
  Future<Map<String, dynamic>?> findOne(int id);
}