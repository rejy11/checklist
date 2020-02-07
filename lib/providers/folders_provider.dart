import 'package:checklist/models/folder_model.dart';
import 'package:checklist/repository/list_repository.dart';
import 'package:flutter/foundation.dart';

class FoldersProvider with ChangeNotifier {
  ListRepository _listRepository;
  bool deleteFolderMode = false;

  FoldersProvider(this._listRepository);

  Future<List<FolderModel>> getFolders() async {
    final folders = await _listRepository.getFolders();
    return folders;
  }

  Future<FolderModel> getFolder(id) async {
    return await _listRepository.getFolder(id);
  }

  Future insertFolder(String name) async {
    final newFolder = FolderModel(
      folderName: name,
      dateTimeCreated: DateTime.now(),
    );

    await _listRepository.insertFolder(newFolder);
    notifyListeners();
  }

  Future deleteFolder(int id) async {
    await _listRepository.deleteFolder(id);
    notifyListeners();
  }

  Future updateFolder(FolderModel folder) async {
    await _listRepository.updateFolder(folder);
    notifyListeners();
  }

  void toggleDeleteFolderMode(bool deleteMode) {
    deleteFolderMode = deleteMode;
    notifyListeners();
  }
}
