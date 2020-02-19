import '../entities/folder_entity.dart';
import '../entities/list_entity.dart';

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

extension ListConversion on ListEntity {
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'completed': this.completed,
      'favourite': this.favourite,
      'dateTimeCreated': this.dateTimeCreated.toString(),
      'folderId': this.folderId,
    };
  }
}
