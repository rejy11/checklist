import '../entities/list_reminder_entity.dart';
import '../enums/repeat_reminder.dart';
import '../models/model_base.dart';

class ListReminderModel extends ModelBase<ListReminderEntity> {
  int id;
  DateTime reminderDateTime;
  bool hasSound;
  RepeatReminder repeatReminder;
  int listId;

  ListReminderModel({
    this.id,
    this.reminderDateTime,
    this.hasSound,
    this.repeatReminder,
    this.listId,
  });

  @override
  ListReminderEntity toEntity() {
    return ListReminderEntity(
      id: id,
      reminderDateTime: reminderDateTime,
      hasSound: hasSound,
      repeatReminder: repeatReminder.index,
      listId: listId,
    );
  }
}
