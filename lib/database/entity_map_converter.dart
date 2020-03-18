import '../entities/folder_entity.dart';
import '../entities/list_entity.dart';
import '../entities/list_item_entity.dart';
import '../entities/list_reminder_entity.dart';

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
      'active': this.active,
      'dateTimeCreated': this.dateTimeCreated.toString(),
      'folderId': this.folderId,
    };
  }
}

extension ListItemConversion on ListItemEntity {
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'completed': this.completed,
      'listId': this.listId,
    };
  }
}

extension ListReminderConversion on ListReminderEntity {
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'reminderDateTime': this.reminderDateTime.toString(),
      'hasSound': this.hasSound,
      'repeatReminder': this.repeatReminder,
      'listId': this.listId,
    };
  }
}
