import 'package:checklist/entities/list_entity.dart';
import 'package:checklist/models/list_model.dart';
import 'package:flutter/foundation.dart';
import '../repository/lists_repository.dart';

class ListsProvider extends ChangeNotifier {
  ListsRepository _listsRepository;

  List<ListModel> _lists;
  int _currentFolderId;

  ListsProvider(
    this._listsRepository,
  ) {
    initialise();
  }

  Future<List<ListModel>> get lists async  {
    return _lists;
  }

  void initialise() async {

  }

  Future fetchLists() async {
    if(_currentFolderId == null) return; 

    final listEntities = await _listsRepository.getLists(_currentFolderId);
    final listModels = List<ListModel>();
    for (var list in listEntities) {
      var listModel = ListModel(
        id: list.id,
        name: list.name,
        completed: list.completed,
        favourite: list.favourite,
        dateTimeCreated: list.dateTimeCreated,
        numberOfItems: await _listsRepository.getNumberOfItemsInList(list.id),
        folderId: list.folderId,
      );
      listModels.add(listModel);
    }
    _lists = listModels;
    notifyListeners();
  }

  void loadListsForFolder(int folderId) async {
    _currentFolderId = folderId;
    await fetchLists();
  }

  Future insertList(String text) async {
    if(_currentFolderId == null) return;
    
    final newList = ListEntity(
      name: text,
      completed: false,
      favourite: false,
      dateTimeCreated: DateTime.now(),
      folderId: _currentFolderId,
    );
    await _listsRepository.insertList(newList);
    await fetchLists();
  }

  Future updateList(ListModel list) async {
    await _listsRepository.updateList(list.toEntity());
    await fetchLists();
  }

}
