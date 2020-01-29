import 'package:checklist/database/sqlite_database.dart';
import 'package:checklist/repository/list_repository.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator.registerSingleton<LocalDatabase>(LocalDatabase());
  serviceLocator.registerSingleton<ListRepository>(ListRepository());
}