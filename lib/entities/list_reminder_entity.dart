class ListReminderEntity {
  final int id;
  final DateTime reminderDateTime;
  final bool hasSound;
  final int repeatReminder;
  final int listId;

  ListReminderEntity({
    this.id,
    this.reminderDateTime,
    this.hasSound,
    this.repeatReminder,
    this.listId,
  });
}
