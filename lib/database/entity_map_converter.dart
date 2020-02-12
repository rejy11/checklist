import '../entities/folder_entity.dart';

extension FolderConversion on FolderEntity {
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.folderName,
      'dateTimeCreated': this.dateTimeCreated.toString(),
      'favourite': this.isFavourite,
    };
  }
}
