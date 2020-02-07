import 'package:checklist/database/model_map_converter.dart';
import 'package:checklist/models/folder_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    final directory = await getDatabasesPath();
    String path = join(directory, "dog.db");

    //uncomment if you want the database to be recreated each time
    deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        debugPrint('Database OnUpgrade');
      },
      onCreate: (Database db, int version) async {
        debugPrint('Database OnCreate');
        await db.execute(
          "CREATE TABLE Folder(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dateTimeCreated TEXT)",
        );
        await db.execute(
          'CREATE TABLE List(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, completed INTEGER,' +
              'favourite INTEGER, sortOrderIndex INTEGER, dateTimeCreated TEXT, folderId INTEGER,' +
              'FOREIGN KEY(folderId) REFERENCES Folder(id) ON DELETE CASCADE)',
        );
        await db.execute(
          'CREATE TABLE ListItem(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, completed INTEGER,'
          'listId INTEGER, FOREIGN KEY(listId) REFERENCES List(id) ON DELETE CASCADE)',
        );

        final folder = FolderModel(
          id: 0,
          folderName: 'Test',
          dateTimeCreated: DateTime.now(),
        );

        await db.insert('Folder', folder.toMap());
      },
    );
  }

  Future<List<FolderModel>> folders() async {
    final db = await database;
    final folderMaps = await db.query('Folder');
    final folders = List<FolderModel>();

    for (var folderMap in folderMaps) {
      final folderId = folderMap['id'];
      final numberOfListsInFolder = await db.rawQuery(
        'SELECT COUNT(*) AS "number_of_lists" FROM List WHERE folderId = $folderId',
      );
      folders.add(FolderModel(
        id: folderId,
        folderName: folderMap['name'],
        dateTimeCreated: DateTime.parse(folderMap['dateTimeCreated']),
        numberOfLists: numberOfListsInFolder[0]['number_of_lists'],
      ));
    }
    return folders;
  }

  Future<void> insertFolder(FolderModel folder) async {
    final db = await database;
    await db.insert('Folder', folder.toMap());
    print('folder inserted to db');
  }

  Future<void> deleteFolder(int id) async {
    final db = await database;
    await db.delete(
      'Folder',
      where: "id = ?",
      whereArgs: [id],
    );
    print('folder deleted from db');
  }

  Future<void> updateFolder(FolderModel folder) async {
    final db = await database;
    await db.update(
      'Folder',
      folder.toMap(),
      where: "id = ?",
      whereArgs: [folder.id],
    );
    print('folder updated');
  }
}
