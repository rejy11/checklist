import 'package:get_it/get_it.dart';

import '../database/sqlite_database.dart';
import '../repository/list_repository.dart';
import '../repository/user_settings_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator.registerSingleton<LocalDatabase>(LocalDatabase());
  serviceLocator.registerSingleton<ListRepository>(ListRepository(serviceLocator()));
  serviceLocator.registerSingleton<UserSettingsRepository>(UserSettingsRepository());
}