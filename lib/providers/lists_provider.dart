import 'package:checklist/enums/repeat_reminder.dart';
import 'package:checklist/repository/user_settings_repository.dart';
import 'package:flutter/foundation.dart';

import '../enums/lists_sort.dart';
import '../enums/order_by.dart';
import '../entities/list_entity.dart';
import '../models/list_model.dart';
import '../models/list_reminder_model.dart';
import '../repository/lists_repository.dart';

class ListsProvider extends ChangeNotifier {
  ListsRepository _listsRepository;
  UserSettingsRepository _userSettingsRepository;

  List<ListModel> _lists;
  List<ListModel> _selectedLists = List<ListModel>();
  int _currentFolderId;
  bool selectListMode = false;
  ListsSort _sortBy;
  OrderBy _orderBy;
  bool _isFavouritesPinned;

  ListsProvider(
    this._listsRepository,
    this._userSettingsRepository,
  );

  List<ListModel> get lists {
    return _lists;
  }

  void loadListsForFolder(int folderId) async {
    _currentFolderId = folderId;
    await getUserSettingsForScreen();
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
      final reminder =
          await _listsRepository.getReminder(list.id); // get reminder
      if (reminder != null) {
        // if reminder is not null
        listModel.reminder = ListReminderModel(
          id: reminder.id,
          reminderDateTime: reminder.reminderDateTime,
          repeatReminder: RepeatReminder.values[reminder.repeatReminder],
          hasSound: reminder.hasSound,
          listId: reminder.listId,
        );
      }
      listModels.add(listModel);
    }
    _lists = listModels;
    applySortOrder(_lists);
    notifyListeners();
  }

  Future getUserSettingsForScreen() async {
    _sortBy = await _userSettingsRepository.getListsSortBySetting();
    _orderBy = await _userSettingsRepository.getListsOrderBySetting();
    _isFavouritesPinned =
        await _userSettingsRepository.getListsFavouritesPinnedSetting();
  }

  Future setUserSettingsForScreen(ListsSort sort, OrderBy order) async {
    await _userSettingsRepository.setListsSortBy(sort);
    await _userSettingsRepository.setListsOrderBy(order);
    await getUserSettingsForScreen();
    await fetchLists();
  }

  ListsSort get sortBy {
    return _sortBy;
  }

  OrderBy get orderBy {
    return _orderBy;
  }

  bool get isFavouritesPinned {
    return _isFavouritesPinned;
  }

  void applySortOrder(List<ListModel> lists) {
    if (_sortBy != null && _orderBy != null) {
      int Function(ListModel, ListModel) compare;

      switch (_sortBy) {
        case ListsSort.DateCreated:
          if (_orderBy == OrderBy.Ascending) {
            compare = (ListModel a, ListModel b) =>
                a.dateTimeCreated.compareTo(b.dateTimeCreated);
          } else {
            compare = (ListModel a, ListModel b) =>
                b.dateTimeCreated.compareTo(a.dateTimeCreated);
          }
          break;
        default:
      }

      if (isFavouritesPinned) {
        final favouriteLists =
            _getSortedList(lists.where((l) => l.favourite).toList(), compare);
        final standardLists =
            _getSortedList(lists.where((l) => !l.favourite).toList(), compare);
        _lists.clear();
        _lists.addAll(favouriteLists);
        _lists.addAll(standardLists);
      } else {
        _lists.sort(compare);
      }
    }
  }

  Future setIsFavouritesPinnedSetting(bool value) async {
    await _userSettingsRepository.setListsFavouritePinnedSetting(value);
    await getUserSettingsForScreen();
    await fetchLists();
  }

  Future insertList(String text) async {
    if (_currentFolderId == null) return;

    final newList = ListEntity(
      name: text,
      completed: false,
      favourite: false,
      dateTimeCreated: DateTime.now(),
      active: true,
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
    _selectedLists.forEach((l) async => _listsRepository.deleteList(l.id));
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

  void toggleListSelected(ListModel list) {
    if (_selectedLists.contains(list)) {
      _selectedLists.remove(list);
    } else {
      _selectedLists.add(list);
    }
    notifyListeners();
  }

  void toggleAllListsSelected(bool value, bool activeLists) {
    _selectedLists.clear();
    if (value) {
      _selectedLists.addAll(_lists.where((l) => l.active == activeLists));
    }
    notifyListeners();
  }

  bool isSelected(ListModel list) {
    return _selectedLists.contains(list);
  }

  bool atleastOneListSelected(bool activeLists) {
    return _selectedLists.where((l) => l.active == activeLists).length > 0;
  }

  bool allListsSelected(bool activeLists) {
    if (_selectedLists == null || _lists == null) return false;
    return _selectedLists.where((l) => l.active == activeLists).length ==
        _lists.where((l) => l.active == activeLists).length;
  }

  List<ListModel> _getSortedList(
      List<ListModel> list, int Function(ListModel, ListModel) compareFunc) {
    list.sort(compareFunc);
    return list;
  }

  Future setReminder(ListReminderModel reminder) async {
    if (reminder.listId != null) {
      await _listsRepository.insertReminder(reminder.toEntity());
    }
  }

  Future updateReminder(ListReminderModel reminder) async {
    if (reminder.listId != null) {
      await _listsRepository.updateReminder(reminder.toEntity());
    }
  }

  Future deleteReminder(int reminderId) async {
    await _listsRepository.deleteReminder(reminderId);
  }
}
