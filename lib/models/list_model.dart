import 'package:checklist/models/list_item_model.dart';

class ListModel {
  final int id;
  String name;
  bool completed;
  bool favourite;
  int sortOrderIndex;
  DateTime dateTimeCreated;
  List<ListItemModel> items;
  int folderId;

  ListModel(this.id);

}