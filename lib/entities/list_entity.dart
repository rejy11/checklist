class ListEntity {
  final int id;
  final String name;
  final bool completed;
  final bool favourite;
  final bool active;
  final DateTime dateTimeCreated;
  final int folderId;

  ListEntity({
    this.id,
    this.name,
    this.completed,
    this.favourite,
    this.active,
    this.dateTimeCreated,
    this.folderId,
  });
}
