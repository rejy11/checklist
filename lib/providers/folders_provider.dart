import 'package:checklist/enums/folders_order_by.dart';
import 'package:checklist/models/folder_model.dart';
import 'package:checklist/repository/user_settings_repository.dart';

import '../entities/folder_entity.dart';
import 'package:checklist/repository/list_repository.dart';
import 'package:flutter/foundation.dart';

class FoldersProvider with ChangeNotifier {
  ListRepository _listRepository;
  UserSettingsRepository _userSettingsRepository;

  bool deleteFolderMode = false;
  List<int> _checkedFolders = List<int>();
  FoldersOrderBy _orderBy;

  FoldersProvider(
    this._listRepository,
    this._userSettingsRepository,
  ) {
    initialise();
  }

  void initialise() async {
    setOrderBy(await _userSettingsRepository.getFoldersSortOrder());
  }

  Future<List<FolderModel>> getFolders() async {
    print('folders_provider - getFolders()');
    final folderEntities = await _listRepository.getFolders(orderBy: _orderBy);
    var folderModels = List<FolderModel>();
    for (var folderEntity in folderEntities) {
      var folderModel = FolderModel(
        id: folderEntity.id,
        name: folderEntity.folderName,
        dateTimeCreated: folderEntity.dateTimeCreated,
        isFavourite: folderEntity.isFavourite,
        numberOfLists:
            await _listRepository.getNumberOfListsInFolder(folderEntity.id),
      );
      folderModel.isCheckedToBeDeleted = isFolderChecked(folderModel.id);
      folderModels.add(folderModel);
    }
    return folderModels;
  }

  Future<FolderModel> getFolder(id) async {
    final folderEntity = await _listRepository.getFolder(id);
    final folderModel = FolderModel(
      id: folderEntity.id,
      name: folderEntity.folderName,
      dateTimeCreated: folderEntity.dateTimeCreated,
      isFavourite: folderEntity.isFavourite,
      numberOfLists:
          await _listRepository.getNumberOfListsInFolder(folderEntity.id),
    );
    folderModel.isCheckedToBeDeleted = isFolderChecked(folderModel.id);
    return folderModel;
  }

  Future insertFolder(String name) async {
    final newFolder = FolderEntity(
      folderName: name,
      dateTimeCreated: DateTime.now(),
      isFavourite: false,
    );
    await _listRepository.insertFolder(newFolder);
    notifyListeners();
  }

  Future deleteFolders() async {
    if (_checkedFolders.length == 0) return;
    for (var folder in _checkedFolders) {
      await _listRepository.deleteFolder(folder);
    }
    deleteFolderMode = false;
    _checkedFolders.clear();
    notifyListeners();
  }

  Future updateFolder(FolderModel folder) async {
    await _listRepository.updateFolder(folder.toEntity());
    notifyListeners();
  }

  void toggleDeleteFolderMode(bool deleteMode) {
    deleteFolderMode = deleteMode;
    _checkedFolders.clear();
    notifyListeners();
  }

  void toggleFolderDeleteCheckbox(int folderId, bool value) {
    if (_checkedFolders.contains(folderId)) {
      _checkedFolders.remove(folderId);
    } else {
      _checkedFolders.add(folderId);
    }
    notifyListeners();
  }

  bool atleastOneFolderChecked() {
    return _checkedFolders.length > 0;
  }

  bool isFolderChecked(int folderId) {
    return _checkedFolders.contains(folderId);
  }

  void setOrderBy(FoldersOrderBy orderBy) {
    _orderBy = orderBy;
    _userSettingsRepository.setFoldersSortOrder(orderBy);
    notifyListeners();
  }

  FoldersOrderBy get orderBy {
    return _orderBy;
  }
}
