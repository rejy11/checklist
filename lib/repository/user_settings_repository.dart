import 'package:checklist/enums/folders_order_by.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsRepository {
  Future<SharedPreferences> userPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<FoldersOrderBy> getFoldersSortOrder() async {
    final prefs = await userPrefs();
    final value = prefs.getString('FoldersOrderBy');
    if (value != null) {
      switch (value) {
        case 'Newest':
          return FoldersOrderBy.Newest;
          break;
        case 'Oldest':
          return FoldersOrderBy.Oldest;
          break;
        case 'Favourite':
          return FoldersOrderBy.Favourite;
          break;
        default:
          return FoldersOrderBy.Newest;
      }
    } else {
      //save default
      await setFoldersSortOrder(FoldersOrderBy.Newest);
    }
    return FoldersOrderBy.Newest;
  }

  Future setFoldersSortOrder(FoldersOrderBy orderBy) async {
    final prefs = await userPrefs();
    await prefs.setString('FoldersOrderBy', orderBy.toString().split('.').last);
  }
}
