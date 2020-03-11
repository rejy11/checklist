import '../entities/list_entity.dart';
import '../models/model_base.dart';
import '../models/list_reminder_model.dart';

class ListModel extends ModelBase<ListEntity> {
  int id;
  String name;
  bool completed;
  bool favourite;
  bool active;
  DateTime dateTimeCreated;
  int numberOfItems;
  int folderId;
  ListReminderModel reminder;

  ListModel({
    this.id,
    this.name,
    this.completed,
    this.favourite,
    this.active,
    this.dateTimeCreated,
    this.numberOfItems,
    this.folderId,
    this.reminder,
  });

  @override
  ListEntity toEntity() {
    return ListEntity(
      id: id,
      name: name,
      completed: completed,
      favourite: favourite,
      active: active,
      dateTimeCreated: dateTimeCreated,
      folderId: folderId,
    );
  }
}
