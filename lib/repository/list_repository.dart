import 'package:checklist/database/sqlite_database.dart';
import 'package:checklist/models/folder_model.dart';

class ListRepository {
  LocalDatabase database;

  Future<List<FolderModel>> getFolders() async {
    return await database.folders();
  }

  Future<FolderModel> getFolder(int id) async {
    final folders = await database.folders();
    final folder = folders.firstWhere((f) => f.id == id);
    return folder;
  }
}