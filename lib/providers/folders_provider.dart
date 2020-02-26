import 'package:flutter/foundation.dart';

import '../entities/folder_entity.dart';
import '../enums/folders_order_by.dart';
import '../models/folder_model.dart';
import '../repository/folders_repository.dart';
import '../repository/user_settings_repository.dart';

class FoldersProvider with ChangeNotifier {
  FoldersRepository _foldersRepository;
  UserSettingsRepository _userSettingsRepository;

  List<FolderModel> _folders;
  bool deleteFolderMode = false;
  bool _allFoldersCheckedCheckBox = false;
  List<int> _checkedFolders = List<int>();
  FoldersOrderBy _orderBy;

  FoldersProvider(
    this._foldersRepository,
    this._userSettingsRepository,
  );

  Future<List<FolderModel>> get folders async {
    return _folders;
  }

  void loadFolders() async {
    _orderBy = await _userSettingsRepository.getFoldersSortOrder();
    await fetchFolders();
  }

  Future fetchFolders() async {
    print('folders_provider - getFolders()');
    final folderEntities =
        await _foldersRepository.getFolders(orderBy: _orderBy);
    var folderModels = List<FolderModel>();
    for (var folderEntity in folderEntities) {
      var folderModel = FolderModel(
          id: folderEntity.id,
          name: folderEntity.folderName,
          dateTimeCreated: folderEntity.dateTimeCreated,
          isFavourite: folderEntity.isFavourite,
          numberOfLists: await _foldersRepository
              .getNumberOfListsInFolder(folderEntity.id),
          isCheckedToBeDeleted: _checkedFolders.contains(folderEntity.id));
      folderModels.add(folderModel);
    }
    _folders = folderModels;
    notifyListeners();
  }

  Future insertFolder(String name) async {
    final newFolder = FolderEntity(
      folderName: name,
      dateTimeCreated: DateTime.now(),
      isFavourite: false,
    );
    await _foldersRepository.insertFolder(newFolder);
    await fetchFolders();
  }

  Future deleteFolders() async {
    // if (_checkedFolders.length == 0) return;
    // for (var folder in _checkedFolders) {
    //   await _foldersRepository.deleteFolder(folder);
    // }
    // deleteFolderMode = false;
    // _checkedFolders.clear();
    // await fetchFolders();

    final foldersToBeDeleted =
        _folders.where((f) => f.isCheckedToBeDeleted).toList();
    if (foldersToBeDeleted.length == 0) return;
    for (var folder in foldersToBeDeleted) {
      await _foldersRepository.deleteFolder(folder.id);
    }
    _checkedFolders.clear();
    deleteFolderMode = false;
    foldersToBeDeleted.forEach((f) => f.isCheckedToBeDeleted = false);
    await fetchFolders();
  }

  Future updateFolder(FolderModel folder) async {
    await _foldersRepository.updateFolder(folder.toEntity());
    await fetchFolders();
  }

  void toggleDeleteFolderMode(bool deleteMode) {
    deleteFolderMode = deleteMode;
    //_checkedFolders.clear();
    _folders.forEach((f) => f.isCheckedToBeDeleted = false);
    notifyListeners();
  }

  void toggleFolderDeleteCheckbox(int folderId, bool value) {
    if (_checkedFolders.contains(folderId)) {
      _checkedFolders.remove(folderId);
      _allFoldersCheckedCheckBox = false;
    } else {
      _checkedFolders.add(folderId);
    }

    _folders.firstWhere((f) => f.id == folderId).isCheckedToBeDeleted = value;
    notifyListeners();
  }

  void toggleAllFoldersDeleteCheckbox(bool value) async {
    // if (!value) {
    //   _checkedFolders.clear();
    //   _allFoldersCheckedCheckBox = false;
    // } else {
    //   _allFoldersCheckedCheckBox = true;
    //   if (_checkedFolders.isNotEmpty) {
    //     _checkedFolders.clear();
    //   }
    //   for (var folder in _folders) {
    //     _checkedFolders.add(folder.id);
    //   }
    // }
    _folders.forEach((f) => f.isCheckedToBeDeleted = value);
    if (value) {
      _checkedFolders.addAll(_folders.map((f) => f.id));
    } else {
      _checkedFolders.clear();
    }
    notifyListeners();
  }

  bool atleastOneFolderChecked() {
     return _checkedFolders.length > 0;
    //return _folders.any((f) => f.isCheckedToBeDeleted);
  }

  // bool isFolderChecked(int folderId) {
  //   return _checkedFolders.contains(folderId);
  // }

  void setOrderBy(FoldersOrderBy orderBy) async {
    _orderBy = orderBy;
    await _userSettingsRepository.setFoldersSortOrder(orderBy);
    await fetchFolders();
  }

  FoldersOrderBy get orderBy {
    return _orderBy;
  }

  bool get allFoldersChecked {
    if(_folders == null) return false;
    return _folders.every((f) => f.isCheckedToBeDeleted);
  }
}
