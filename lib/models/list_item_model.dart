import 'package:checklist/entities/list_item_entity.dart';
import 'model_base.dart';

class ListItemModel extends ModelBase<ListItemEntity> {
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