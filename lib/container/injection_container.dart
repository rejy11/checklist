import 'package:get_it/get_it.dart';

import '../database/sqlite_database.dart';
import '../repository/folders_repository.dart';
import '../repository/lists_repository.dart';
import '../repository/user_settings_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator.registerSingleton<LocalDatabase>(LocalDatabase());
  serviceLocator.registerSingleton<FoldersRepository>(FoldersRepository(serviceLocator()));
  serviceLocator.registerSingleton<ListsRepository>(ListsRepository(serviceLocator()));
  serviceLocator.registerSingleton<UserSettingsRepository>(UserSettingsRepository());
}