import 'package:checklist/database/sqlite_database.dart';
import 'package:checklist/entities/list_entity.dart';

class ListsRepository {
  LocalDatabase _database;

  ListsRepository(this._database);

  Future<List<ListEntity>> getLists(int folderId) async {
    return await _database.lists(folderId);
  }

  Future<int> getNumberOfItemsInList(int listId) async {
    return await _database.getNumberOfItemsInList(listId);
  }

  Future updateList(ListEntity list) async {
    await _database.updateList(list);
  }

  Future insertList(ListEntity list) async {
    await _database.insertList(list);
  }
}