class ListReminderEntity {
  final int id;
  final DateTime reminderDateTime;
  final bool hasSound;
  final bool repeatReminder;
  final int listId;

  ListReminderEntity({
    this.id,
    this.reminderDateTime,
    this.hasSound,
    this.repeatReminder,
    this.listId,
  });
}
