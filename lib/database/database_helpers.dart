import 'package:checklist/entities/folder_entity.dart';
import 'package:checklist/entities/list_entity.dart';
import 'package:checklist/entities/list_item_entity.dart';

class DatabaseHelpers {
  static bool intToBoolConverter(int value) {
    if (value == 1) return true;
    return false;
  }

  static List<FolderEntity> generateFolderTestData() {
    return [
      FolderEntity(
        folderName: 'Untitled',
        dateTimeCreated: DateTime.now(),
        isFavourite: false,
      ),
      // FolderEntity(
      //   folderName: 'Important',
      //   dateTimeCreated: DateTime.now(),
      //   isFavourite: true,
      // ),
      // FolderEntity(
      //   folderName: 'Work Related',
      //   dateTimeCreated: DateTime.now(),
      //   isFavourite: false,
      // ),
    ];
  }

  static List<ListEntity> generateListTestData() {
    return [
      ListEntity(
        name: 'Weekly shop',
        completed: true,
        dateTimeCreated: DateTime.now(),
        favourite: true,
        active: true,
        folderId: 1,
      ),
      ListEntity(
        name: 'Holiday',
        completed: true,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: true,
        folderId: 1,
      ),
      ListEntity(
        name: 'Home DIY',
        completed: false,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: true,
        folderId: 1,
      ),
      ListEntity(
        name: 'Moving House',
        completed: true,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: true,
        folderId: 1,
      ),
      ListEntity(
        name: 'Christmas Presents',
        completed: false,
        dateTimeCreated: DateTime.now(),
        favourite: false,
        active: true,
        folderId: 1,
      ),
      ListEntity(
        name: 'Project Tasks',
        completed: false,
        dateTimeCreated: DateTime.now(),
        favourite: true,
        active: true,
        folderId: 1,
      ),
      // ListEntity(
      //   name: 'Moving House',
      //   completed: true,
      //   dateTimeCreated: DateTime.now(),
      //   favourite: false,
      //   active: false,
      //   folderId: 3,
      // ),
      // ListEntity(
      //   name: 'Christmas Presents',
      //   completed: false,
      //   dateTimeCreated: DateTime.now(),
      //   favourite: false,
      //   active: false,
      //   folderId: 3,
      // ),
      // ListEntity(
      //   name: 'Project Tasks',
      //   completed: false,
      //   dateTimeCreated: DateTime.now(),
      //   favourite: true,
      //   active: false,
      //   folderId: 3,
      // ),
    ];
  }

  static List<ListItemEntity> generateListItemTestData() {
    return [
      ListItemEntity(
        name: 'Milk',
        completed: false,
        listId: 1
      ),
      ListItemEntity(
        name: 'Bread',
        completed: false,
        listId: 1
      ),
      ListItemEntity(
        name: 'Cereals',
        completed: false,
        listId: 1
      ),
      ListItemEntity(
        name: 'Fags',
        completed: true,
        listId: 1
      ),
    ];
  }
}
