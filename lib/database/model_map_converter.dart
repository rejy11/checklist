import 'package:checklist/models/folder_model.dart';

extension FolderConversion on FolderModel {
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.folderName,
      'dateTimeCreated': this.dateTimeCreated.toString(),
    };
  }
}
