import 'package:flutter/foundation.dart';

import '../entities/list_entity.dart';
import '../models/list_model.dart';
import '../repository/lists_repository.dart';

class ListsProvider extends ChangeNotifier {
  ListsRepository _listsRepository;

  List<ListModel> _lists;
  int _currentFolderId;
  bool selectListMode = false;
  List<int> _selectedLists = List<int>();

  ListsProvider(
    this._listsRepository,
  );

  List<ListModel> get lists {
    return _lists;
  }

  void loadListsForFolder(int folderId) async {
    _currentFolderId = folderId;
    await fetchLists();
  }

  Future fetchLists() async {
    if (_currentFolderId == null) return;

    final listEntities = await _listsRepository.getLists(_currentFolderId);
    final listModels = List<ListModel>();
    for (var list in listEntities) {
      var listModel = ListModel(
        id: list.id,
        name: list.name,
        completed: list.completed,
        favourite: list.favourite,
        active: list.active,
        dateTimeCreated: list.dateTimeCreated,
        numberOfItems: await _listsRepository.getNumberOfItemsInList(list.id),
        folderId: list.folderId,
      );
      listModels.add(listModel);
    }
    _lists = listModels;
    notifyListeners();
  }

  Future insertList(String text) async {
    if (_currentFolderId == null) return;

    final newList = ListEntity(
      name: text,
      completed: false,
      favourite: false,
      dateTimeCreated: DateTime.now(),
      active: false,
      folderId: _currentFolderId,
    );
    await _listsRepository.insertList(newList);
    await fetchLists();
  }

  Future updateList(ListModel list) async {
    await _listsRepository.updateList(list.toEntity());
    await fetchLists();
  }

  Future deleteSelectedLists() async {
    _selectedLists.forEach((l) async => _listsRepository.deleteList(l));
    _selectedLists.clear();
    await fetchLists();
  }

  void toggleSelectListMode(bool selectListMode) {
    this.selectListMode = selectListMode;
    if (!selectListMode) {
      _selectedLists.clear();
    }
    notifyListeners();
  }

  void toggleListSelected(int listId) {
    if (_selectedLists.contains(listId)) {
      _selectedLists.remove(listId);
    } else {
      _selectedLists.add(listId);
    }
    notifyListeners();
  }

  void toggleAllListsSelected(bool value) {
    _selectedLists.clear();
    if (value) {
      _selectedLists.addAll(_lists.map((l) => l.id));
    }
    notifyListeners();
  }

  bool isSelected(int listId) {
    return _selectedLists.contains(listId);
  }

  bool atleastOneListSelected() {
    return _selectedLists.length > 0;
  }

  bool allListsSelected() {
    if (_selectedLists == null || _lists == null) return false;
    return _selectedLists.length == _lists.length;
  }
}
