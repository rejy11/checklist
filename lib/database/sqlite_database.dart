import 'package:checklist/entities/list_entity.dart';
import 'package:checklist/enums/folders_order_by.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import './database_helpers.dart';
import '../entities/folder_entity.dart';
import 'entity_map_converter.dart';

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
          "CREATE TABLE Folder(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT(15), dateTimeCreated TEXT, favourite BOOLEAN NOT NULL CHECK (favourite IN (0,1)))",
        );
        await db.execute(
          'CREATE TABLE List(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT(15), completed INTEGER,' +
              'favourite INTEGER, dateTimeCreated TEXT, folderId INTEGER,' +
              'FOREIGN KEY(folderId) REFERENCES Folder(id) ON DELETE CASCADE)',
        );
        await db.execute(
          'CREATE TABLE ListItem(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT(15), completed INTEGER,'
          'listId INTEGER, FOREIGN KEY(listId) REFERENCES List(id) ON DELETE CASCADE)',
        );

        final folders = DatabaseHelpers.generateFolderTestData();
        for (var folder in folders) {
          await db.insert('Folder', folder.toMap());
        }
        final lists = DatabaseHelpers.generateListTestData();
        for (var list in lists) {
          await db.insert('List', list.toMap());
        }

        // for (var i = 0; i < 10; i++) {
        //   final folder = FolderEntity(
        //     id: i,
        //     folderName: 'Test $i folder',
        //     dateTimeCreated: DateTime.now(),
        //     isFavourite: i % 2 == 0 ? true : false,
        //   );
        //   final list = ListEntity(
        //     id: i,
        //     name: 'Test $i List',
        //     completed: false,
        //     dateTimeCreated: DateTime.now(),
        //     favourite: false,
        //     folderId: i,
        //   );

        //   await db.insert('Folder', folder.toMap());
        //   await db.insert('List', list.toMap());
        // }
      },
    );
  }

  // FOLDERS ---------------------------------------------------------------------

  Future<List<FolderEntity>> folders({FoldersOrderBy orderBy}) async {
    final db = await database;

    var orderByString = '';

    switch (orderBy) {
      case FoldersOrderBy.Newest:
        orderByString = 'dateTimeCreated desc';
        break;
      case FoldersOrderBy.Oldest:
        orderByString = 'dateTimeCreated';
        break;
      case FoldersOrderBy.Favourite:
        orderByString = 'favourite desc';
        break;
      default:
        orderByString = 'datetime(dateTimeCreated) desc';
    }
    final folderMaps = await db.query('Folder', orderBy: orderByString);

    final folders = List<FolderEntity>();

    for (var folderMap in folderMaps) {
      folders.add(FolderEntity(
        id: folderMap['id'],
        folderName: folderMap['name'],
        dateTimeCreated: DateTime.parse(folderMap['dateTimeCreated']),
        isFavourite: DatabaseHelpers.intToBoolConverter(folderMap['favourite']),
      ));
    }
    return folders;
  }

  Future<int> getNumberOfListsInFolder(int folderId) async {
    final db = await database;
    final numberOfListsInFolder = await db.rawQuery(
      'SELECT COUNT(*) AS "number_of_lists" FROM List WHERE folderId = $folderId',
    );
    return numberOfListsInFolder[0]['number_of_lists'];
  }

  Future<void> insertFolder(FolderEntity folder) async {
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

  Future<void> updateFolder(FolderEntity folder) async {
    final db = await database;
    await db.update(
      'Folder',
      folder.toMap(),
      where: "id = ?",
      whereArgs: [folder.id],
    );
    print('folder updated');
  }

  // LISTS ---------------------------------------------------------------------

  Future<List<ListEntity>> lists(int folderId) async {
    final db = await database;
    final listMaps = await db.query(
      'List',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );
    final lists = List<ListEntity>();

    listMaps.forEach((l) {
      lists.add(ListEntity(
        id: l['id'],
        name: l['name'],
        completed: DatabaseHelpers.intToBoolConverter(l['completed']),
        favourite: DatabaseHelpers.intToBoolConverter(l['favourite']),
        dateTimeCreated: DateTime.parse(l['dateTimeCreated']),
        folderId: l['folderId'],
      ));
    });

    return lists;
  }

  Future<int> getNumberOfItemsInList(int listId) async {
    final db = await database;
    final numberOfListsInFolder = await db.rawQuery(
      'SELECT COUNT(*) AS "number_of_items" FROM ListItem WHERE listId = $listId',
    );
    return numberOfListsInFolder[0]['number_of_items'];
  }

  Future updateList(ListEntity list) async {
    final db = await database;
    await db.update(
      'List',
      list.toMap(),
      where: "id = ?",
      whereArgs: [list.id],
    );
    print('list updated');
  }

  Future insertList(ListEntity list) async {
    final db = await database;
    await db.insert('List', list.toMap());
    print('list inserted');
  }
}
