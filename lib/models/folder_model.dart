import '../entities/folder_entity.dart';

class FolderModel {
  int id;
  String name;
  DateTime dateTimeCreated;
  int numberOfLists;
  bool isFavourite;
  bool isCheckedToBeDeleted = false;

  FolderModel({
    this.id,
    this.name,
    this.dateTimeCreated,
    this.numberOfLists,
    this.isFavourite,
    this.isCheckedToBeDeleted,
  });

  FolderEntity toEntity() {
    return FolderEntity(
      id: id,
      folderName: name,
      dateTimeCreated: dateTimeCreated,
      isFavourite: isFavourite,
    );
  }
}
