import '../database/sqlite_database.dart';
import '../entities/list_entity.dart';
import '../entities/list_reminder_entity.dart';

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

  Future deleteList(int id) async {
    await _database.deleteList(id);
  }

  Future<ListReminderEntity> getReminder(int listId) async {
    return await _database.getListReminder(listId);
  }

  Future insertReminder(ListReminderEntity reminder) async {
    await _database.insertListReminder(reminder);
  }

  Future deleteReminder(int reminderId) async {
    await _database.deleteListReminder(reminderId);
  }

  Future updateReminder(ListReminderEntity reminder) async {
    await _database.updateListReminder(reminder);
  }
}