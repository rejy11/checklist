import 'package:checklist/entities/list_item_entity.dart';

import '../models/list_item_model.dart';
import 'package:flutter/foundation.dart';
import '../repository/list_items_repository.dart';

class ListItemsProvider extends ChangeNotifier {
  ListItemsRepository _listItemsRepository;

  List<ListItemModel> _listItems;
  int _currentListId;

  ListItemsProvider(this._listItemsRepository);

  List<ListItemModel> get listItems {
    return _listItems;
  }

  void loadListItemsForList(int listId) async {
    _currentListId = listId;
    await fetchListItems();
  }

  Future fetchListItems() async {
    if (_currentListId == null) return;

    final listItemEntities =
        await _listItemsRepository.getListItems(_currentListId);
    final listItemModels = List<ListItemModel>();
    for (var item in listItemEntities) {
      var listItemModel = ListItemModel(
        id: item.id,
        name: item.name,
        completed: item.completed,
        listId: item.listId,
      );
      listItemModels.add(listItemModel);
    }
    _listItems = listItemModels;
    notifyListeners();
  }

  Future insertListItem(String name) async {
    final newItem =
        ListItemEntity(name: name, completed: false, listId: _currentListId);
    await _listItemsRepository.insertListItem(newItem);
    await fetchListItems();
  }

  Future updateListItem(ListItemModel item) async {
    await _listItemsRepository.updateListItem(item.toEntity());
    await fetchListItems();
  }

  Future deleteListItem(int id) async {
    await _listItemsRepository.deleteListItem(id);
    await fetchListItems();
  }
}
