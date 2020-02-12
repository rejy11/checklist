import 'list_item_entity.dart';

class ListEntity {
  final int id;
  String name;
  bool completed;
  bool favourite;
  int sortOrderIndex;
  DateTime dateTimeCreated;
  List<ListItemEntity> items;
  int folderId;

  ListEntity(this.id);
}
