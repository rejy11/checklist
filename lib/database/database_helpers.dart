import 'package:checklist/entities/folder_entity.dart';
import 'package:checklist/entities/list_entity.dart';

class DatabaseHelpers {
  static bool intToBoolConverter(int value) {
    if (value == 1) return true;
    return false;
  }

  static List<FolderEntity> generateFolderTestData() {
    return [
      FolderEntity(
        id: 1,
        folderName: 'Untitled',
        dateTimeCreated: DateTime.now(),
        isFavourite: false,
      ),
      FolderEntity(
        id: 2,
        folderName: 'Important',
        dateTimeCreated: DateTime.now(),
        isFavourite: true,
      ),
      FolderEntity(
        id: 3,
        folderName: 'Work Related',
        dateTimeCreated: DateTime.now(),
        isFavourite: false,
      ),
    ];
  }

  static List<ListEntity> generateListTestData() {
    return [
      ListEntity(
        id: 1,
        name: 'Weekly shop',
        completed: true,
        dateTimeCreated: DateTime.now(),
        favourite: true,
        active: true,
        folderId: 1,
      ),
      ListEntity(
        id: 2,
        name: 'Holiday',
        completed: true,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: true,
        folderId: 1,
      ),
      ListEntity(
        id: 3,
        name: 'Home DIY',
        completed: false,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: true,
        folderId: 1,
      ),
      ListEntity(
        id: 4,
        name: 'Moving House',
        completed: true,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: true,
        folderId: 3,
      ),
      ListEntity(
        id: 5,
        name: 'Christmas Presents',
        completed: false,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: true,
        folderId: 3,
      ),
      ListEntity(
        id: 6,
        name: 'Project Tasks',
        completed: false,
        dateTimeCreated: DateTime.now(),
        favourite: true,
        active: true,
        folderId: 3,
      ),
      ListEntity(
        id: 7,
        name: 'Moving House',
        completed: true,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: false,
        folderId: 3,
      ),
      ListEntity(
        id: 8,
        name: 'Christmas Presents',
        completed: false,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: false,
        folderId: 3,
      ),
      ListEntity(
        id: 9,
        name: 'Project Tasks',
        completed: false,
        dateTimeCreated: DateTime.now(),
        favourite: true,
        active: false,
        folderId: 3,
      ),
    ];
  }
}
