import 'package:checklist/entities/list_item_entity.dart';

class ListItemModel {
  int id;
  String name;
  bool completed;
  int listId;

  ListItemModel({
    this.id,
    this.name,
    this.completed,
    this.listId,
  });

  ListItemEntity toEntity() {
    return ListItemEntity(
      id: id,
      name: name,
      completed: completed,
      listId: listId,
    );
  }
}