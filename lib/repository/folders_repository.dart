import '../database/sqlite_database.dart';
import '../entities/folder_entity.dart';
import '../enums/folders_order_by.dart';

class FoldersRepository {
  LocalDatabase database;

  FoldersRepository(this.database);

  Future<List<FolderEntity>> getFolders({FoldersOrderBy orderBy}) async {
    return await database.folders(orderBy: orderBy);
  }

  Future<FolderEntity> getFolder(int id) async {
    final folders = await database.folders();
    final folder = folders.firstWhere((f) => f.id == id);
    return folder;
  }

  Future<int> getNumberOfListsInFolder(int folderId) async {
    return await database.getNumberOfListsInFolder(folderId);
  }

  Future insertFolder(FolderEntity folder) async {
    await database.insertFolder(folder);
  }

  Future deleteFolder(int id) async {
    await database.deleteFolder(id);
  }

  Future updateFolder(FolderEntity folder) async {
    await database.updateFolder(folder);
  }
}
