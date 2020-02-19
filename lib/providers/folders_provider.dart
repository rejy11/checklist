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
  ) {
    initialise();
  }

  void initialise() async {
    setOrderBy(await _userSettingsRepository.getFoldersSortOrder());
  }

  Future<List<FolderModel>> get folders async {
    return _folders;
  }

  Future fetchFolders() async {
    print('folders_provider - getFolders()');
    final folderEntities = await _foldersRepository.getFolders(orderBy: _orderBy);
    var folderModels = List<FolderModel>();
    for (var folderEntity in folderEntities) {
      var folderModel = FolderModel(
        id: folderEntity.id,
        name: folderEntity.folderName,
        dateTimeCreated: folderEntity.dateTimeCreated,
        isFavourite: folderEntity.isFavourite,
        numberOfLists:
            await _foldersRepository.getNumberOfListsInFolder(folderEntity.id),
      );
      folderModel.isCheckedToBeDeleted = isFolderChecked(folderModel.id);
      folderModels.add(folderModel);
    }
    _folders = folderModels;
    notifyListeners();
  }

  // Future<FolderModel> getFolder(id) async {
  //   final folderEntity = await _listRepository.getFolder(id);
  //   final folderModel = FolderModel(
  //     id: folderEntity.id,
  //     name: folderEntity.folderName,
  //     dateTimeCreated: folderEntity.dateTimeCreated,
  //     isFavourite: folderEntity.isFavourite,
  //     numberOfLists:
  //         await _listRepository.getNumberOfListsInFolder(folderEntity.id),
  //   );
  //   folderModel.isCheckedToBeDeleted = isFolderChecked(folderModel.id);
  //   return folderModel;
  // }

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
    if (_checkedFolders.length == 0) return;
    for (var folder in _checkedFolders) {
      await _foldersRepository.deleteFolder(folder);
    }
    deleteFolderMode = false;
    _checkedFolders.clear();
    await fetchFolders();
  }

  Future updateFolder(FolderModel folder) async {
    await _foldersRepository.updateFolder(folder.toEntity());
    await fetchFolders();
  }

  void toggleDeleteFolderMode(bool deleteMode) {
    deleteFolderMode = deleteMode;
    _checkedFolders.clear();
    notifyListeners();
  }

  void toggleFolderDeleteCheckbox(int folderId, bool value) {
    if (_checkedFolders.contains(folderId)) {
      _checkedFolders.remove(folderId);
      _allFoldersCheckedCheckBox = false;
    } else {
      _checkedFolders.add(folderId);
    }
    notifyListeners();
  }

  void toggleAllFoldersDeleteCheckbox(bool value) async {
    if (!value) {
      _checkedFolders.clear();
      _allFoldersCheckedCheckBox = false;
    } else {
      _allFoldersCheckedCheckBox = true;
      if (_checkedFolders.isNotEmpty) {
        _checkedFolders.clear();
      }
      for (var folder in _folders) {
        _checkedFolders.add(folder.id);
      }
    }
    notifyListeners();
  }

  bool atleastOneFolderChecked() {
    return _checkedFolders.length > 0;
  }

  bool isFolderChecked(int folderId) {
    return _checkedFolders.contains(folderId);
  }

  void setOrderBy(FoldersOrderBy orderBy) async {
    _orderBy = orderBy;
    await _userSettingsRepository.setFoldersSortOrder(orderBy);
    await fetchFolders();
  }

  FoldersOrderBy get orderBy {
    return _orderBy;
  }

  bool get allFoldersChecked {
    return _allFoldersCheckedCheckBox;
  }
}
