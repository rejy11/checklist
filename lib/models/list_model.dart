import '../entities/list_entity.dart';

class ListModel {
  int id;
  String name;
  bool completed;
  bool favourite;
  bool active;
  DateTime dateTimeCreated;
  int numberOfItems;
  int folderId;

  ListModel({
    this.id,
    this.name,
    this.completed,
    this.favourite,
    this.active,
    this.dateTimeCreated,
    this.numberOfItems,
    this.folderId,
  });

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
