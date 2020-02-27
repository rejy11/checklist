import 'package:checklist/database/sqlite_database.dart';
import 'package:checklist/entities/list_item_entity.dart';

class ListItemsRepository {
  LocalDatabase _database;

  ListItemsRepository(this._database);

  Future<List<ListItemEntity>> getListItems(int listId) async {
    return await _database.listItems(listId);
  }

  Future insertListItem(ListItemEntity listItem) async {
    await _database.insertListItem(listItem);
  }

  Future deleteListItem(int id) async {
    await _database.deleteListItem(id);
  }

  Future updateListItem(ListItemEntity listItem) async {
    await _database.updateListItem(listItem);
  }
} 