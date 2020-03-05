import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart' as Constants;
import '../enums/folders_order_by.dart';
import '../enums/lists_sort.dart';
import '../enums/order_by.dart';

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

  Future<ListsSort> getListsSortBySetting() async {
    final prefs = await userPrefs();
    final value = prefs.getString(Constants.LISTS_SORT_BY);
    if (value != null) {
      switch (value) {
        case 'DateCreated':
          return ListsSort.DateCreated;
          break;
        default:
      }
    }
    return ListsSort.DateCreated;
  }

  Future setListsSortBy(ListsSort sort) async {
    final prefs = await userPrefs();
    await prefs.setString(
        Constants.LISTS_SORT_BY, sort.toString().split('.').last);
  }

  Future<OrderBy> getListsOrderBySetting() async {
    final prefs = await userPrefs();
    final value = prefs.getString(Constants.LISTS_ORDER_BY);
    if (value != null) {
      switch (value) {
        case 'Ascending':
          return OrderBy.Ascending;
          break;
        case 'Descending':
          return OrderBy.Descending;
          break;
        default:
      }
    }
    return OrderBy.Ascending;
  }

  Future setListsOrderBy(OrderBy order) async {
    final prefs = await userPrefs();
    await prefs.setString(
        Constants.LISTS_ORDER_BY, order.toString().split('.').last);
  }

  Future<bool> getListsFavouritesPinnedSetting() async {
    final prefs = await userPrefs();
    final value = prefs.getBool(Constants.LISTS_PIN_FAVOURITES);
    if(value == null) return false;
    return value;
  }

  Future setListsFavouritePinnedSetting(bool value) async {
    final prefs = await userPrefs();
    await prefs.setBool(Constants.LISTS_PIN_FAVOURITES, value);
  }
}
