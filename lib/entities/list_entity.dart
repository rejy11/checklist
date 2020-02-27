class ListEntity {
  final int id;
  final String name;
  final bool completed;
  final bool favourite;
  final bool active;
  //final int sortOrderIndex;
  final DateTime dateTimeCreated;
  //final List<ListItemEntity> items;
  final int folderId;

  ListEntity({
    this.id,
    this.name,
    this.completed,
    this.favourite,
    this.active,
    //this.sortOrderIndex,
    this.dateTimeCreated,
    //this.items,
    this.folderId,
  });
}
