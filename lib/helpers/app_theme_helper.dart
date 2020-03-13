import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemeHelper {
  static void applyStatusBarTheme(BuildContext context,
      {Color statusBarColour}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColour == null
          ? Theme.of(context).primaryColor
          : statusBarColour,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  static void applyStatusBarThemeForDialog(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }
}
