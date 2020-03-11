import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import '../constants.dart' as Constants;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  Future<void> initialise() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, IOSInitializationSettings());
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
  }

  void configureSelectNotificationSubject(Function function) {
    selectNotificationSubject.stream.listen((String payload) async {
      final listId = int.tryParse(payload);
      if (listId != null) {
        await function(listId);
      }
    });
  }

  Future<void> scheduleNotification(
      int listId, String listName, DateTime reminderDate) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1',
      'list reminder',
      'list reminder description',
      enableLights: true,
      ledOnMs: 1000,
      ledOffMs: 500,
      ledColor: Constants.BACKGROUND_GRADIENT_START, // possible bug, shows as red
      color: Constants.BACKGROUND_GRADIENT_START,
      enableVibration: true,
      playSound: true,
      visibility: NotificationVisibility.Public,
    );
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      IOSNotificationDetails(),
    );
    await _flutterLocalNotificationsPlugin.schedule(
      listId,
      'Reminder at ${reminderDate.toString()}',
      listName,
      reminderDate,
      platformChannelSpecifics,
      payload: listId.toString(),
    );
  }

  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
    );
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      IOSNotificationDetails(),
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      'plain title',
      'plain body',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
