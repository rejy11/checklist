import 'package:checklist/models/folder_model.dart';
import 'package:checklist/repository/list_repository.dart';
import 'package:flutter/foundation.dart';

class FoldersProvider with ChangeNotifier {
  ListRepository _listRepository;

  FoldersProvider(this._listRepository);

  Future<List<FolderModel>> getFolders() async {
    final folders = await _listRepository.getFolders();
    return folders;
  }

  Future<FolderModel> getFolder(id) async {
    return await _listRepository.getFolder(id);
  }
}